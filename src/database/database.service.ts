import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import postgres from 'postgres';
import { drizzle, PostgresJsDatabase } from 'drizzle-orm/postgres-js';

@Injectable()
export class DatabaseService implements OnModuleDestroy {
  private readonly client: postgres.Sql;
  readonly db: PostgresJsDatabase;

  constructor(private readonly configService: ConfigService) {
    const databaseUrl = this.configService.getOrThrow<string>('DATABASE_URL');

    this.client = postgres(databaseUrl, {
      max: 10,
      prepare: false,
    });

    this.db = drizzle(this.client);
  }

  async onModuleDestroy(): Promise<void> {
    await this.client.end();
  }
}
