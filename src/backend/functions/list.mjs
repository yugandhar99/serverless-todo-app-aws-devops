import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, ScanCommand } from '@aws-sdk/lib-dynamodb';

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

const parsePositiveInt = (value, fallback, max) => {
  const number = Number.parseInt(value, 10);
  if (Number.isNaN(number) || number < 1) return fallback;
  return Math.min(number, max);
};

export const handler = async (event) => {
  const limit = parsePositiveInt(event?.queryStringParameters?.limit, 50, 100);

  try {
    const result = await dynamoDb.send(new ScanCommand({
      TableName: tableName,
      Limit: limit,
    }));

    const items = (result.Items || []).sort((a, b) => String(b.createdAt).localeCompare(String(a.createdAt)));

    return response(200, {
      items,
      count: items.length,
      nextKey: result.LastEvaluatedKey || null,
    });
  } catch (error) {
    console.error(JSON.stringify({ event: 'todo_list_failed', message: error.message, stack: error.stack }));
    return response(500, { message: 'Could not fetch todos.' });
  }
};
