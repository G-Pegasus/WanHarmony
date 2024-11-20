export class ObjectCopy {
  public static copy<T extends object>(target: T, source: T): T {
    for (const key of Object.keys(source)) {
      Reflect.set(target, key, Reflect.get(source, key))
    }
    return target;
  }
}