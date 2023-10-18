#!/bin/bash
service_name=""  
while getopts "s:" arg; do
  case $arg in
    s)
      service_name=$OPTARG
      ;;
  esac
done

if   [ -z "$service_name" ]; then
  echo 'Error: service_name not passed with arg -s.' >&2
  exit 1
fi

mkdir -p src/$service_name


repository_template="aW1wb3J0IHsgIEh0dHBFeGNlcHRpb24sIEh0dHBTdGF0dXMsIEluamVjdGFibGUgfSBmcm9tICdAbmVzdGpzL2NvbW1vbic7CmltcG9ydCB7IEluamVjdERhdGFTb3VyY2UgfSBmcm9tICdAbmVzdGpzL3R5cGVvcm0nOwppbXBvcnQgeyBEYXRhU291cmNlIH0gZnJvbSAndHlwZW9ybSc7CmltcG9ydCB7CiAgICBTRVJWSUNFX05BTUVFbnRpdHksCiAgICBTRVJWSUNFX05BTUVDcmVhdGVEdG8sCiAgICBTRVJWSUNFX05BTUVVcGRhdGVEdG8sCiAgICBTRVJWSUNFX05BTUVGaWx0ZXIsCiAgICBTRVJWSUNFX05BTUVQYWdpbmF0aW9uUmVzdWx0cwp9IGZyb20gJy4vTE9XRVJfU1ZSX05BTUUuZHRvJwoKQEluamVjdGFibGUoKQpleHBvcnQgY2xhc3MgU0VSVklDRV9OQU1FUmVwb3NpdG9yeXsgCiAgICBjb25zdHJ1Y3RvcihASW5qZWN0RGF0YVNvdXJjZSgpIHByaXZhdGUgZGF0YVNvdXJjZTogRGF0YVNvdXJjZSkge30KCiAgICAKICAgIGFzeW5jIGNyZWF0ZShtb2RlbDogU0VSVklDRV9OQU1FQ3JlYXRlRHRvKToKICAgICAgICBQcm9taXNlPFNFUlZJQ0VfTkFNRUVudGl0eT4gewogICAgICAgIHRyeXsKICAgICAgICBjb25zdCByZXN1bHRzID0gYXdhaXQgdGhpcy5kYXRhU291cmNlLnF1ZXJ5KAogICAgICAgICAgYAogICAgICAgICAgICBJTlNFUlQgaW50byAgU0VSVklDRV9OQU1FICgKICAgICAgICAgICAgICAgICR7T2JqZWN0LmtleXMobW9kZWwpLmpvaW4oIiwiKX0KICAgICAgICAgICAgKSBWQUxVRVMgKAogICAgICAgICAgICAgICR7T2JqZWN0LmtleXMobW9kZWwpCiAgICAgICAgICAgICAgICAubWFwKChrZXkpID0+ICc/JykKICAgICAgICAgICAgICAgIC5qb2luKCcsJyl9CiAgICAgICAgICAgICAgKQogICAgICAgICAgICBgLAogICAgICAgICAgICBPYmplY3Qua2V5cyhtb2RlbCkubWFwKGtleT0+bW9kZWxba2V5XSkKICAgICAgICApOwogICAgCiAgICAgICAgY29uc3QgaW5zZXJ0ZWQgPSBhd2FpdCB0aGlzLmdldChyZXN1bHRzLmluc2VydElkKTsKICAgICAgICByZXR1cm4gaW5zZXJ0ZWQ7CiAgICB9Y2F0Y2ggKGUpIHsKICAgICAgdGhyb3cgbmV3IEh0dHBFeGNlcHRpb24oZS5tZXNzYWdlLCBIdHRwU3RhdHVzLkJBRF9SRVFVRVNUKTsKICAgIH0KICAgIH0KICAgIAogICAgYXN5bmMgZ2V0KGlkOiBudW1iZXIpOgogICAgICAgIFByb21pc2U8U0VSVklDRV9OQU1FRW50aXR5PiB7CiAgICAgICAgY29uc3QgcmVzdWx0cyA9IGF3YWl0IHRoaXMuZGF0YVNvdXJjZS5xdWVyeSgKICAgICAgICAgIGAKICAgICAgICAgICAgU0VMRUNUICogRlJPTSBTRVJWSUNFX05BTUUgV0hFUkUgaWQ9PwogICAgICAgICAgICBgLAogICAgICAgICAgW2lkXSwKICAgICAgICApOwogICAgCiAgICAgICAgcmV0dXJuIHJlc3VsdHMubGVuZ3RoID8gcmVzdWx0c1swXSA6IG51bGw7CiAgICB9CgogICAgYXN5bmMgbGlzdChmaWx0ZXI6IFNFUlZJQ0VfTkFNRUZpbHRlcik6CiAgICAgICAgUHJvbWlzZTxTRVJWSUNFX05BTUVFbnRpdHlbXT4gewogICAgICAgIAogICAgICAgICAgICBjb25zdCBxdWVyeSA9IGZpbHRlcj9PYmplY3Qua2V5cyhmaWx0ZXIpCiAgICAgICAgICAgIC5tYXAoKGtleSkgPT4gewogICAgICAgICAgICAgIGlmICghZmlsdGVyW2tleV0pIHJldHVybiBudWxsOwogICAgICAgICAgICAgIHJldHVybiBgJHtrZXl9PT9gOwogICAgICAgICAgICB9KQogICAgICAgICAgICAuZmlsdGVyKChwKSA9PiBwICE9IG51bGwpCiAgICAgICAgICAgIC5qb2luKCIsIik6IiI7CiAgICAgICAgICBjb25zdCByZXN1bHRzID0gYXdhaXQgdGhpcy5kYXRhU291cmNlLnF1ZXJ5KAogICAgICAgICAgICBgCiAgICAgICAgICAgICAgICAgIFNFTEVDVCAqIEZST00gU0VSVklDRV9OQU1FCiAgICAgICAgICAgICAgICAgICR7cXVlcnkubGVuZ3RoID8gYFdIRVJFICR7cXVlcnl9YCA6ICIifQogICAgICAgICAgICAgICAgICBPUkRFUiBCWSBjcmVhdGVkIGRlc2MKICAgICAgICAgICAgICAgICAgYCwKICAgICAgICAgICAgZmlsdGVyP09iamVjdC5rZXlzKGZpbHRlcikuZmlsdGVyKChwKSA9PiBwICE9IG51bGwpOltdCiAgICAgICAgICApOwogICAgICAgIAogICAgICAgIHJldHVybiByZXN1bHRzCiAgICB9CgogICAgYXN5bmMgcGFnaW5hdGUoZmlsdGVyOiBTRVJWSUNFX05BTUVGaWx0ZXIscGFnZTpudW1iZXI9MSxwYWdlU2l6ZTpudW1iZXI9MjAsb3JkZXJCeUNvbHVtbjpzdHJpbmc9J2NyZWF0ZWQnLG9yZGVyVHlwZTpzdHJpbmc9J2Rlc2MnKToKICAgIFByb21pc2U8U0VSVklDRV9OQU1FUGFnaW5hdGlvblJlc3VsdHM+IHsKICAgIAogICAgICAgIGNvbnN0IHF1ZXJ5ID0gZmlsdGVyP09iamVjdC5rZXlzKGZpbHRlcikKICAgICAgICAubWFwKChrZXkpID0+IHsKICAgICAgICAgIGlmICghZmlsdGVyW2tleV0pIHJldHVybiBudWxsOwogICAgICAgICAgcmV0dXJuIGAke2tleX09P2A7CiAgICAgICAgfSkKICAgICAgICAuZmlsdGVyKChwKSA9PiBwICE9IG51bGwpCiAgICAgICAgICAgIC5qb2luKCIsIikgOiAiIjsKICAgICAgbGV0IHRvdGFsSXRlbXM9IGF3YWl0IHRoaXMuZGF0YVNvdXJjZS5xdWVyeSgKICAgICAgICBgCiAgICAgICAgICAgICAgU0VMRUNUIENPVU5UKCopIGFzIHRvdGFsIEZST00gU0VSVklDRV9OQU1FCiAgICAgICAgICAgICAgJHtxdWVyeS5sZW5ndGggPyBgV0hFUkUgJHtxdWVyeX1gIDogIiJ9CiAgICAgICAgICAgICAgYCwKICAgICAgICBmaWx0ZXI/T2JqZWN0LmtleXMoZmlsdGVyKS5maWx0ZXIoKGtleSkgPT4gZmlsdGVyW2tleV0gIT0gbnVsbCkubWFwKGtleT0+ZmlsdGVyW2tleV0pOltdCiAgICAgICk7CiAgICAgICAgCiAgICAgdG90YWxJdGVtcyA9IHBhcnNlSW50KHRvdGFsSXRlbXNbMF1bJ3RvdGFsJ10pOwogICAgICAgIGNvbnN0IHRvdGFsUGFnZXMgPSBNYXRoLmNlaWwodG90YWxJdGVtcyAvIHBhZ2VTaXplKTsKICAgICAgICBjb25zdCBzdGFydEF0ID0gcGFnZVNpemUgKiAocGFnZSAtIDEpOwoKICAgICAgY29uc3QgcmVzdWx0cyA9IGF3YWl0IHRoaXMuZGF0YVNvdXJjZS5xdWVyeSgKICAgICAgICBgCiAgICAgICAgICAgICAgU0VMRUNUICogRlJPTSBTRVJWSUNFX05BTUUKICAgICAgICAgICAgICAke3F1ZXJ5Lmxlbmd0aCA/IGBXSEVSRSAke3F1ZXJ5fWAgOiAiIn0KICAgICAgICAgICAgICBPUkRFUiBCWSAke29yZGVyQnlDb2x1bW59ICR7b3JkZXJUeXBlfQogICAgICAgICAgICAgIExJTUlUICR7c3RhcnRBdH0sICR7cGFnZVNpemV9CiAgICAgICAgICAgICAgYCwKICAgICAgICBmaWx0ZXI/T2JqZWN0LmtleXMoZmlsdGVyKS5maWx0ZXIoKGtleSkgPT4gZmlsdGVyW2tleV0gIT0gbnVsbCkubWFwKGtleT0+ZmlsdGVyW2tleV0pOltdCiAgICAgICk7CiAgICAKICAgICAgICByZXR1cm4gewogICAgICAgICAgICBmaWx0ZXIsCiAgICAgICAgICAgIHBhZ2UsCiAgICAgICAgICAgIHBhZ2VTaXplLAogICAgICAgICAgICB0b3RhbDogdG90YWxJdGVtcywKICAgICAgICAgICAgcGFnZXM6IHRvdGFsUGFnZXMsCiAgICAgICAgICAgIHJlc3VsdHMKICAgIH0KfQoKICAgIGFzeW5jIGRlbGV0ZShpZDogbnVtYmVyKTogUHJvbWlzZTx2b2lkPiB7CiAgICAgICAgIGNvbnN0IHJlc3VsdHMgPSAgYXdhaXQgdGhpcy5kYXRhU291cmNlLnF1ZXJ5KAogICAgICAgICAgICBgCiAgICAgICAgICAgIERFTEVURSBGUk9NIFNFUlZJQ0VfTkFNRSBXSEVSRSBpZD0/CiAgICAgICAgICAgIGAsCiAgICAgICAgICAgIFtpZF0sCiAgICAgICAgKTsKICAgICAgICBpZiAoIXJlc3VsdHMuYWZmZWN0ZWRSb3dzKSB7CiAgICAgIHRocm93IG5ldyBIdHRwRXhjZXB0aW9uKCdOb3QgZm91bmQnLCBIdHRwU3RhdHVzLk5PVF9GT1VORCk7CiAgICB9CiAKICAgIH0KCiAgICBhc3luYyB1cGRhdGUoaWQ6IG51bWJlciwgbW9kZWw6IFNFUlZJQ0VfTkFNRVVwZGF0ZUR0byk6CiAgICAgICAgUHJvbWlzZTxTRVJWSUNFX05BTUVFbnRpdHk+IHsKICAgICAgICAgIHRyeXsKICAgICAgICBjb25zdCB2YWx1ZXM9T2JqZWN0LmtleXMobW9kZWwpLm1hcChrZXk9Pm1vZGVsW2tleV0pCiAgICAgICAgY29uc3QgcmVzdWx0cyA9IGF3YWl0IHRoaXMuZGF0YVNvdXJjZS5xdWVyeSgKICAgICAgICAgICAgYAogICAgICAgICAgICBVUERBVEUgU0VSVklDRV9OQU1FCiAgICAgICAgICAgIFNFVAogICAgICAgICAgICAke09iamVjdC5rZXlzKG1vZGVsKS5tYXAoa2V5PT5gJHtrZXl9PT9gKS5qb2luKCIsIil9CiAgICAgICAgICAgIFdIRVJFIGlkPT8KICAgICAgICAgICAgYCwKICAgICAgICAgICAgWwogICAgICAgICAgICAgICAgLi4udmFsdWVzLAogICAgICAgICAgICAgICAgaWQKICAgICAgICAgICAgXSwKICAgICAgICApOwogICAgICAgIGlmICghcmVzdWx0cy5hZmZlY3RlZFJvd3MpIHsKICAgICAgICB0aHJvdyBuZXcgSHR0cEV4Y2VwdGlvbignTm90IGZvdW5kJywgSHR0cFN0YXR1cy5OT1RfRk9VTkQpOwogICAgICAgfQogICAgICAgIGNvbnN0IHVwZGF0ZWQgPSBhd2FpdCB0aGlzLmdldChpZCk7CiAgICAgICAgcmV0dXJuIHVwZGF0ZWQKICAgIH1jYXRjaCAoZSkgewogICAgICB0aHJvdyBuZXcgSHR0cEV4Y2VwdGlvbihlLm1lc3NhZ2UsIEh0dHBTdGF0dXMuQkFEX1JFUVVFU1QpOwogICAgfQogICAgfQoKfQ=="
repository_dto_template="aW1wb3J0IHsKICBJc0FscGhhbnVtZXJpYywKICBJc0VtYWlsLAogIElzRW51bSwKICBJc0ludCwKICBJc05vdEVtcHR5LAogIElzU3RyaW5nLAogIE1hdGNoZXMsCiAgTWluTGVuZ3RoLAp9IGZyb20gJ2NsYXNzLXZhbGlkYXRvcic7CgogCgoKZXhwb3J0IGNsYXNzIFNFUlZJQ0VfTkFNRUVudGl0eSB7CiAgaWQ6IG51bWJlcjsKICB4OiBzdHJpbmc7Cn0KCmV4cG9ydCBjbGFzcyBTRVJWSUNFX05BTUVDcmVhdGVEdG8gewogIEBJc1N0cmluZygpCiAgQE1pbkxlbmd0aCgyLCB7IG1lc3NhZ2U6ICdOYW1lIG11c3QgaGF2ZSBhdGxlYXN0IDIgY2hhcmFjdGVycy4nIH0pCiAgQElzTm90RW1wdHkoKQogIHg6IHN0cmluZzsKCiAgLyoqCiAgQElzTm90RW1wdHkoKQogIEBNYXRjaGVzKC9eKD89LipbYS16XSkoPz0uKltBLVpdKSg/PS4qZCkoPz0uKltAJCElKj8mXSlbQS1aYS16ZEAkISUqPyZdezgsMjB9JC8sIHsKICAgIG1lc3NhZ2U6IGBQYXNzd29yZCBtdXN0IGNvbnRhaW4gTWluaW11bSA4IGFuZCBtYXhpbXVtIDIwIGNoYXJhY3RlcnMsIAogICAgYXQgbGVhc3Qgb25lIHVwcGVyY2FzZSBsZXR0ZXIsIAogICAgb25lIGxvd2VyY2FzZSBsZXR0ZXIsIAogICAgb25lIG51bWJlciBhbmQgCiAgICBvbmUgc3BlY2lhbCBjaGFyYWN0ZXJgLAogIH0pCiAgcGFzc3dvcmQ6IHN0cmluZzsKICAqLwp9CgpleHBvcnQgY2xhc3MgU0VSVklDRV9OQU1FVXBkYXRlRHRvIHsKICB4OiBzdHJpbmc7Cn0KCmV4cG9ydCBjbGFzcyBTRVJWSUNFX05BTUVGaWx0ZXIgewogIHg6IHN0cmluZzsKfQoKZXhwb3J0IGNsYXNzIFNFUlZJQ0VfTkFNRVBhZ2luYXRpb25SZXN1bHRzIHsKICBwYWdlOiBudW1iZXI7CiAgcGFnZVNpemU6IG51bWJlcjsKICB0b3RhbDogbnVtYmVyOwogIHBhZ2VzOiBudW1iZXI7CiAgZmlsdGVyOiBTRVJWSUNFX05BTUVGaWx0ZXI7CiAgcmVzdWx0czogU0VSVklDRV9OQU1FRW50aXR5W107Cn0K"

echo $repository_template | base64 -d > repository-template.txt
echo $repository_dto_template | base64 -d > repository-dto-template.txt
 
capitalize_service_name="$(tr '[:lower:]' '[:upper:]' <<< ${service_name:0:1})${service_name:1}"
echo $capitalize_service_name
awk -v env_var="$capitalize_service_name" '{sub("SERVICE_NAME",env_var)} {print}' repository-template.txt   > temp.txt && mv temp.txt src/$service_name/$service_name.repository.ts
awk -v env_var="$service_name" '{sub("LOWER_SVR_NAME",env_var)} {print}' src/$service_name/$service_name.repository.ts   > temp.txt && mv temp.txt src/$service_name/$service_name.repository.ts
awk -v env_var="$capitalize_service_name" '{sub("SERVICE_NAME",env_var)} {print}' repository-dto-template.txt   > temp.txt && mv temp.txt src/$service_name/$service_name.dto.ts

rm -Rf repository-template.txt
rm -Rf repository-dto-template.txt
CONTROLLER=$capitalize_service_name
CONTROLLER+="Controller"
SERVICE=$capitalize_service_name
SERVICE+="Service"
REPOSITORY=$capitalize_service_name
REPOSITORY+="Repository"
MODULE=$capitalize_service_name
MODULE+="Module"
echo "import { Module } from '@nestjs/common';
import { $SERVICE } from './$service_name.service';
import { $CONTROLLER } from './$service_name.controller';
import { $REPOSITORY } from './$service_name.repository';

@Module({
  controllers: [$CONTROLLER],
  providers: [$SERVICE,$REPOSITORY],
})
export class $MODULE {}
">src/$service_name/$service_name.module.ts


SERVICE_LOWER=$service_name
SERVICE_LOWER+="Service"

REPOSITORY_LOWER=$service_name
REPOSITORY_LOWER+="Repository"
CREATE_DTO=$capitalize_service_name
CREATE_DTO+="CreateDto"
FILTER=$capitalize_service_name
FILTER+="Filter"
ENTITY=$capitalize_service_name
ENTITY+="Entity"

PAGINATION_RESULTS=$capitalize_service_name
PAGINATION_RESULTS+="PaginationResults"
UPDATE_DTO=$capitalize_service_name
UPDATE_DTO+="UpdateDto"
$(cat << EOF > src/$service_name/$service_name.service.ts
import {Injectable} from '@nestjs/common';
import {$REPOSITORY} from './$service_name.repository';
import {$CREATE_DTO, $FILTER, $UPDATE_DTO ,$ENTITY,$PAGINATION_RESULTS} from './$service_name.dto';

@Injectable()
export class $SERVICE {
   constructor(private readonly $REPOSITORY_LOWER: $REPOSITORY) {}

  async create(model: $CREATE_DTO):Promise<$ENTITY> {
    return this.$REPOSITORY_LOWER.create(model);
  }

  async list(filter: $FILTER):Promise<$ENTITY[]> {
    return this.$REPOSITORY_LOWER.list(filter);
  }

  async paginate(
    filter: $FILTER,
    page: number = 1,
    pageSize: number = 20,
    orderByColumn: string = 'created',
    orderType: string = 'desc',
  ):Promise<$PAGINATION_RESULTS>{
    return this.$REPOSITORY_LOWER.paginate(
      filter,
      page,
      pageSize,
      orderByColumn,
      orderType,
    );
  }

  async get(id: number):Promise<$ENTITY>  {
    return this.$REPOSITORY_LOWER.get(id);
  }

  async update(id: number, model: $UPDATE_DTO):Promise<$ENTITY>  {
    return this.$REPOSITORY_LOWER.update(id, model);
  }

  async delete(id: number) {
    return this.$REPOSITORY_LOWER.delete(id);
  }
}
EOF) 

$(cat << EOF >src/$service_name/$service_name.controller.ts
import { Body, Controller, Delete, Get, Param,Post, Put, Query} from '@nestjs/common';
import { $SERVICE } from './$service_name.service';
import { $CREATE_DTO, $FILTER, $UPDATE_DTO ,$ENTITY,$PAGINATION_RESULTS} from './$service_name.dto';


@Controller('$service_name')
export class $CONTROLLER {
  constructor(private readonly $SERVICE_LOWER: $SERVICE) {}

    @Post()
  async create(@Body() dto: $CREATE_DTO): Promise<$ENTITY> {
    return this.$SERVICE_LOWER.create(dto);
  }

  @Get()
  async paginate(
    @Query() filter: $FILTER,
    @Query('page') page: number,
  ): Promise<$PAGINATION_RESULTS> {
    return this.$SERVICE_LOWER.paginate(filter, page);
  }

  @Get(':id')
  async get(@Param('id') id: number): Promise<$ENTITY> {
    return this.$SERVICE_LOWER.get(id);
  }

  @Put(':id')
  async update(
    @Param('id') id: number,
    @Body() dto: $UPDATE_DTO,
  ): Promise<$ENTITY> {
    return this.$SERVICE_LOWER.update(id, dto);
  }

  @Delete(':id')
  async delete(@Param('id') id: number): Promise<void> {
    return this.$SERVICE_LOWER.delete(id);
  }
}
EOF)