import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, UpdateCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const dynamoDb = DynamoDBDocumentClient.from(client, {
  marshallOptions: { removeUndefinedValues: true },
});

const tableName = process.env.DYNAMODB_TABLE;
const headers = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': process.env.CORS_ALLOW_ORIGIN || '*',
  'Access-Control-Allow-Headers': 'Content-Type,Authorization,X-Requested-With',
  'Access-Control-Allow-Methods': 'OPTIONS,GET,POST,PUT,DELETE',
};

const response = (statusCode, body) => ({
  statusCode,
  headers,
  body: JSON.stringify(body),
});

const parseJsonBody = (body) => {
  if (!body) return {};
  return typeof body === 'string' ? JSON.parse(body) : body;
};

const validateTodo = (data) => {
  if (typeof data.text !== 'string' || !data.text.trim()) return 'Todo text is required.';
  if (data.text.trim().length > 200) return 'Todo text must be 200 characters or fewer.';
  if (typeof data.checked !== 'boolean') return 'Todo checked status must be boolean.';
  return null;
};

export const handler = async (event) => {
  const id = event?.pathParameters?.id;

  if (!id) {
    return response(400, { message: 'Todo id is required.' });
  }

  try {
    const data = parseJsonBody(event.body);
    const validationError = validateTodo(data);

    if (validationError) {
      return response(400, { message: validationError });
    }

    const result = await dynamoDb.send(new UpdateCommand({
      TableName: tableName,
      Key: { id },
      ExpressionAttributeNames: {
        '#todo_text': 'text',
      },
      ExpressionAttributeValues: {
        ':text': data.text.trim(),
        ':checked': data.checked,
        ':updatedAt': new Date().toISOString(),
      },
      UpdateExpression: 'SET #todo_text = :text, checked = :checked, updatedAt = :updatedAt',
      ConditionExpression: 'attribute_exists(id)',
      ReturnValues: 'ALL_NEW',
    }));

    console.log(JSON.stringify({ event: 'todo_updated', todoId: id }));
    return response(200, result.Attributes);
  } catch (error) {
    if (error instanceof SyntaxError) {
      return response(400, { message: 'Request body must be valid JSON.' });
    }

    if (error.name === 'ConditionalCheckFailedException') {
      return response(404, { message: 'Todo item was not found.' });
    }

    console.error(JSON.stringify({ event: 'todo_update_failed', todoId: id, message: error.message, stack: error.stack }));
    return response(500, { message: 'Could not update the todo item.' });
  }
};
