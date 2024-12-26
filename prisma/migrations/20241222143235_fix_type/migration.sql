/*
  Warnings:

  - The primary key for the `permission` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `permission` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `role` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `role` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `session` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `session` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `provider` column on the `user` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `user_permission` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `user_permission` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `user_role` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `user_role` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Changed the type of `method` on the `permission` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `permission_id` on the `user_permission` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `role_id` on the `user_permission` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `role_id` on the `user_role` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "Provider" AS ENUM ('GOOGLE', 'FACEBOOK', 'EMAIL');

-- CreateEnum
CREATE TYPE "HttpMethod" AS ENUM ('GET', 'POST', 'PUT', 'DELETE', 'PATCH');

-- DropForeignKey
ALTER TABLE "user_permission" DROP CONSTRAINT "user_permission_permission_id_fkey";

-- DropForeignKey
ALTER TABLE "user_permission" DROP CONSTRAINT "user_permission_role_id_fkey";

-- DropForeignKey
ALTER TABLE "user_role" DROP CONSTRAINT "user_role_role_id_fkey";

-- AlterTable
ALTER TABLE "permission" DROP CONSTRAINT "permission_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "method",
ADD COLUMN     "method" "HttpMethod" NOT NULL,
ALTER COLUMN "path" SET DATA TYPE VARCHAR(55),
ALTER COLUMN "category" SET DATA TYPE VARCHAR(20),
ADD CONSTRAINT "permission_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "role" DROP CONSTRAINT "role_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "role_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "session" DROP CONSTRAINT "session_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "session_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "user" DROP COLUMN "provider",
ADD COLUMN     "provider" "Provider",
ALTER COLUMN "deleted_at" SET DEFAULT null;

-- AlterTable
ALTER TABLE "user_permission" DROP CONSTRAINT "user_permission_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "permission_id",
ADD COLUMN     "permission_id" INTEGER NOT NULL,
DROP COLUMN "role_id",
ADD COLUMN     "role_id" INTEGER NOT NULL,
ADD CONSTRAINT "user_permission_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "user_role" DROP CONSTRAINT "user_role_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "role_id",
ADD COLUMN     "role_id" INTEGER NOT NULL,
ADD CONSTRAINT "user_role_pkey" PRIMARY KEY ("id");

-- CreateIndex
CREATE UNIQUE INDEX "user_permission_role_id_permission_id_key" ON "user_permission"("role_id", "permission_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_role_user_id_role_id_key" ON "user_role"("user_id", "role_id");

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "role"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_permission" ADD CONSTRAINT "user_permission_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "role"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_permission" ADD CONSTRAINT "user_permission_permission_id_fkey" FOREIGN KEY ("permission_id") REFERENCES "permission"("id") ON DELETE CASCADE ON UPDATE CASCADE;
