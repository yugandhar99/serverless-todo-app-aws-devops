import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand } from '@aws-sdk/lib-dynamodb';

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
    const result = await dynamoDb.send(new GetCommand({
      TableName: tableName,
      Key: { id },
    }));

    if (!result.Item) {
      return response(404, { message: 'Todo item was not found.' });
    }

    return response(200, result.Item);
  } catch (error) {
    console.error(JSON.stringify({ event: 'todo_get_failed', todoId: id, message: error.message, stack: error.stack }));
    return response(500, { message: 'Could not fetch the todo item.' });
  }
};
