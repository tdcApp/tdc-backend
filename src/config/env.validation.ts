import { plainToInstance } from 'class-transformer';
import { IsIn, IsInt, IsNotEmpty, IsString, IsUrl, validateSync } from 'class-validator';

class EnvironmentVariables {
  @IsIn(['development', 'production', 'test'])
  NODE_ENV!: string;

  @IsInt()
  PORT!: number;

  @IsString()
  @IsNotEmpty()
  DATABASE_URL!: string;

  @IsUrl({ require_tld: false })
  @IsNotEmpty()
  UPSTASH_REDIS_REST_URL!: string;

  @IsString()
  @IsNotEmpty()
  UPSTASH_REDIS_REST_TOKEN!: string;

  @IsString()
  @IsNotEmpty()
  FIREBASE_PROJECT_ID!: string;

  @IsString()
  @IsNotEmpty()
  FIREBASE_CLIENT_EMAIL!: string;

  @IsString()
  @IsNotEmpty()
  FIREBASE_PRIVATE_KEY!: string;
}

export function validateEnvironment(config: Record<string, unknown>): Record<string, unknown> {
  const validatedConfig = plainToInstance(EnvironmentVariables, config, {
    enableImplicitConversion: true,
  });

  const errors = validateSync(validatedConfig, {
    skipMissingProperties: false,
  });

  if (errors.length > 0) {
    throw new Error(
      `Environment validation failed:\n${errors
        .map((error) => Object.values(error.constraints ?? {}).join(', '))
        .join('\n')}`,
    );
  }

  return {
    ...config,
    NODE_ENV: validatedConfig.NODE_ENV,
    PORT: validatedConfig.PORT,
    DATABASE_URL: validatedConfig.DATABASE_URL,
    UPSTASH_REDIS_REST_URL: validatedConfig.UPSTASH_REDIS_REST_URL,
    UPSTASH_REDIS_REST_TOKEN: validatedConfig.UPSTASH_REDIS_REST_TOKEN,
    FIREBASE_PROJECT_ID: validatedConfig.FIREBASE_PROJECT_ID,
    FIREBASE_CLIENT_EMAIL: validatedConfig.FIREBASE_CLIENT_EMAIL,
    FIREBASE_PRIVATE_KEY: validatedConfig.FIREBASE_PRIVATE_KEY,
  };
}
