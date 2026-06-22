import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, DeleteCommand } from '@aws-sdk/lib-dynamodb';

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

export const handler = async (event) => {
  const id = event?.pathParameters?.id;

  if (!id) {
    return response(400, { message: 'Todo id is required.' });
  }

  try {
    await dynamoDb.send(new DeleteCommand({
      TableName: tableName,
      Key: { id },
      ConditionExpression: 'attribute_exists(id)',
    }));

    console.log(JSON.stringify({ event: 'todo_deleted', todoId: id }));
    return response(200, { id, deleted: true });
  } catch (error) {
    if (error.name === 'ConditionalCheckFailedException') {
      return response(404, { message: 'Todo item was not found.' });
    }

    console.error(JSON.stringify({ event: 'todo_delete_failed', todoId: id, message: error.message, stack: error.stack }));
    return response(500, { message: 'Could not remove the todo item.' });
  }
};
