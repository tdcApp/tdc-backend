import { IsEnum, IsOptional } from 'class-validator';
import type { ClassTypeEnum } from '../../database/schema';

export class GetClassesQueryDto {
  @IsOptional()
  @IsEnum(['LANGUAGE', 'TECHNOLOGY'])
  type?: ClassTypeEnum;
}
