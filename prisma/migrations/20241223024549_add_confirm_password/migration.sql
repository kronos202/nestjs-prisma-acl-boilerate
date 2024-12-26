-- AlterTable
ALTER TABLE "user" ADD COLUMN     "confirmPassword" VARCHAR(255),
ALTER COLUMN "deleted_at" SET DEFAULT null,
ALTER COLUMN "provider" SET DEFAULT 'EMAIL';
