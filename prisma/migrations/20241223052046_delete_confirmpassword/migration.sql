/*
  Warnings:

  - You are about to drop the column `confirmPassword` on the `user` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "user" DROP COLUMN "confirmPassword",
ALTER COLUMN "deleted_at" SET DEFAULT null;
