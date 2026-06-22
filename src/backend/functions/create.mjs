import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand } from '@aws-sdk/lib-dynamodb';
import { randomUUID } from 'node:crypto';

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

const validateTodoText = (text) => {
  if (typeof text !== 'string') return 'Todo text is required.';
  const trimmed = text.trim();
  if (!trimmed) return 'Todo text cannot be empty.';
  if (trimmed.length > 200) return 'Todo text must be 200 characters or fewer.';
  return null;
};

export const handler = async (event) => {
  try {
    const data = parseJsonBody(event.body);
    const validationError = validateTodoText(data.text);

    if (validationError) {
      return response(400, { message: validationError });
    }

    const timestamp = new Date().toISOString();
    const item = {
      id: randomUUID(),
      text: data.text.trim(),
      checked: false,
      createdAt: timestamp,
      updatedAt: timestamp,
    };

    await dynamoDb.send(new PutCommand({
      TableName: tableName,
      Item: item,
      ConditionExpression: 'attribute_not_exists(id)',
    }));

    console.log(JSON.stringify({ event: 'todo_created', todoId: item.id }));
    return response(201, item);
  } catch (error) {
    if (error instanceof SyntaxError) {
      return response(400, { message: 'Request body must be valid JSON.' });
    }

    console.error(JSON.stringify({ event: 'todo_create_failed', message: error.message, stack: error.stack }));
    return response(500, { message: 'Could not create the todo item.' });
  }
};
