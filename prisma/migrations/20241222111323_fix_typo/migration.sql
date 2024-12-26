/*
  Warnings:

  - You are about to drop the column `isActive` on the `role` table. All the data in the column will be lost.
  - You are about to drop the column `socialId` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `permissionId` on the `user_permission` table. All the data in the column will be lost.
  - You are about to drop the column `roleId` on the `user_permission` table. All the data in the column will be lost.
  - You are about to drop the column `roleId` on the `user_role` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `user_role` table. All the data in the column will be lost.
  - You are about to drop the `Session` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[role_id,permission_id]` on the table `user_permission` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[user_id,role_id]` on the table `user_role` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `permission_id` to the `user_permission` table without a default value. This is not possible if the table is not empty.
  - Added the required column `role_id` to the `user_permission` table without a default value. This is not possible if the table is not empty.
  - Added the required column `role_id` to the `user_role` table without a default value. This is not possible if the table is not empty.
  - Added the required column `user_id` to the `user_role` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Session" DROP CONSTRAINT "Session_userId_fkey";

-- DropForeignKey
ALTER TABLE "user_permission" DROP CONSTRAINT "user_permission_permissionId_fkey";

-- DropForeignKey
ALTER TABLE "user_permission" DROP CONSTRAINT "user_permission_roleId_fkey";

-- DropForeignKey
ALTER TABLE "user_role" DROP CONSTRAINT "user_role_roleId_fkey";

-- DropForeignKey
ALTER TABLE "user_role" DROP CONSTRAINT "user_role_userId_fkey";

-- DropIndex
DROP INDEX "user_permission_roleId_permissionId_key";

-- DropIndex
DROP INDEX "user_role_userId_roleId_key";

-- AlterTable
ALTER TABLE "role" DROP COLUMN "isActive",
ADD COLUMN     "is_active" BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE "user" DROP COLUMN "socialId",
ADD COLUMN     "social_id" TEXT,
ALTER COLUMN "deleted_at" SET DEFAULT null;

-- AlterTable
ALTER TABLE "user_permission" DROP COLUMN "permissionId",
DROP COLUMN "roleId",
ADD COLUMN     "permission_id" TEXT NOT NULL,
ADD COLUMN     "role_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "user_role" DROP COLUMN "roleId",
DROP COLUMN "userId",
ADD COLUMN     "role_id" TEXT NOT NULL,
ADD COLUMN     "user_id" TEXT NOT NULL;

-- DropTable
DROP TABLE "Session";

-- CreateTable
CREATE TABLE "session" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "hash" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_permission_role_id_permission_id_key" ON "user_permission"("role_id", "permission_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_role_user_id_role_id_key" ON "user_role"("user_id", "role_id");

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "role"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_permission" ADD CONSTRAINT "user_permission_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "role"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_permission" ADD CONSTRAINT "user_permission_permission_id_fkey" FOREIGN KEY ("permission_id") REFERENCES "permission"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
