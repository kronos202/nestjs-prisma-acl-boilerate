import { PrismaClient } from '@prisma/client';
// import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  // Tạo role admin, owner nếu chưa có
  // const roles = ['admin', 'owner', 'user'];
  // for (const role of roles) {
  //   await prisma.role.upsert({
  //     where: { name: role },
  //     update: {},
  //     create: { name: role, description: `${role} role` },
  //   });
  // }
  // const permissions = await prisma.permission.createMany({
  //   data: [
  //     {
  //       method: 'GET',
  //       path: '/users',
  //       category: 'User',
  //       description: 'View users',
  //     },
  //     {
  //       method: 'POST',
  //       path: '/users',
  //       category: 'User',
  //       description: 'Create user',
  //     },
  //     {
  //       method: 'DELETE',
  //       path: '/users/:id',
  //       category: 'User',
  //       description: 'Delete user',
  //     },
  //   ],
  //   skipDuplicates: true,
  // });
  // console.log(`${permissions.count} permissions seeded.`);
  // // Kiểm tra xem đã có user admin chưa, nếu chưa thì tạo
  // const adminUser = await prisma.user.findUnique({
  //   where: { email: 'admin@domain.com' },
  // });
  // if (!adminUser) {
  //   // Tạo user admin mặc định
  //   const hashedPassword = await bcrypt.hash('admin123', 10);
  //   const user = await prisma.user.create({
  //     data: {
  //       email: 'admin@domain.com',
  //       username: 'admin',
  //       password: hashedPassword,
  //       firstName: 'Admin',
  //       lastName: 'User',
  //       UserRole: {
  //         create: [
  //           {
  //             role: {
  //               connect: { name: 'admin' }, // Gán role 'admin'
  //             },
  //           },
  //           {
  //             role: {
  //               connect: { name: 'owner' }, // Gán role 'owner'
  //             },
  //           },
  //         ],
  //       },
  //     },
  //   });
  //   console.log('Admin user created with roles "admin" and "owner"');
  // }
  // // Tạo user owner nếu chưa có
  // const ownerUser = await prisma.user.findUnique({
  //   where: { email: 'owner@domain.com' },
  // });
  // if (!ownerUser) {
  //   // Tạo user owner mặc định
  //   const hashedPassword = await bcrypt.hash('owner123', 10);
  //   const user = await prisma.user.create({
  //     data: {
  //       email: 'owner@domain.com',
  //       username: 'owner',
  //       password: hashedPassword,
  //       firstName: 'Owner',
  //       lastName: 'User',
  //       UserRole: {
  //         create: [
  //           {
  //             role: {
  //               connect: { name: 'owner' }, // Gán role 'owner'
  //             },
  //           },
  //           {
  //             role: {
  //               connect: { name: 'admin' }, // Gán role 'admin'
  //             },
  //           },
  //         ],
  //       },
  //     },
  //   });
  //   console.log('Owner user created with roles "admin" and "owner"');
  // }

  await prisma.role.create({
    data: {
      name: 'admin',
      RolePermission: {
        create: [
          { permissionId: 1 }, // Map tới ID của permission
          { permissionId: 2 },
          { permissionId: 3 },
        ],
      },
    },
  });
  await prisma.role.create({
    data: {
      name: 'user',
      RolePermission: {
        create: [
          { permissionId: 1 }, // Map tới ID của permission
          { permissionId: 2 },
        ],
      },
    },
  });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
