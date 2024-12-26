import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { HttpMethod } from '@prisma/client';

@Injectable()
export class PermissionsGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const user = request.user; // Lấy từ JWT hoặc session
    const method: HttpMethod = request.method as HttpMethod;
    let path: string = request.route.path;

    if (!user || user.roles.length === 0) {
      throw new ForbiddenException('Access denied: No roles assigned');
    }

    if (!user.permissions) {
      return false; // Nếu không có user hoặc permissions, từ chối
    }

    // Lấy permissions từ metadata
    const requiredPermissions = this.reflector.get<string[]>(
      'permissions',
      context.getHandler(),
    );

    // Nếu không có permissions yêu cầu (không có metadata @Permissions()), cho phép truy cập
    if (!requiredPermissions || requiredPermissions.length === 0) {
      return true;
    }

    // Loại bỏ "/api" nếu có trong đường dẫn (nếu cần)
    if (path.startsWith('/api')) {
      path = path.slice(4);
    }

    // Kiểm tra xem người dùng có quyền tương ứng hay không
    const hasPermission = user.permissions.some((permission) => {
      return permission.method === method && permission.path === path;
    });

    // Nếu có quyền, cho phép truy cập
    if (hasPermission) {
      return true;
    }

    // Nếu không có permission, kiểm tra nếu user có role đủ quyền
    return user.roles.includes('admin'); // Ví dụ, chỉ admin mới có quyền truy cập nếu không có permission cụ thể
  }
}
