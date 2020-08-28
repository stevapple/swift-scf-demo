# Swift Demo for Tencent SCF Custom Runtime

本项目是对 [SwiftTencenSCFRuntime](https://github.com/stevapple/swift-tencent-scf-runtime) 的单 package 简单 demo，不具备业务价值，仅供参考，可以作为项目模板使用。

## 打包 / 通过控制台部署

本项目附带的打包脚本 `scripts/build.sh` 可以用于在 SCF 环境下进行打包，打包产物位于 `.build/scf/cloud-function.zip`。你可以直接通过控制台上传这个 zip 文件来部署。

*如果你选择通过控制台部署，则需要手动配置 API 网关触发器。*

## 通过 Serverless Framework 部署（推荐）

根据腾讯云官方的最佳实践，推荐使用 Serverless Framework 部署本项目。在打包完成后，运行 `serverless deploy` 即可将整个项目（包括 API 网关部分）部署到腾讯云。

## 通过 COSCMD 和 TCCLI 部署（不推荐）

你可以修改 `scripts/deploy.sh` 中的函数名称、地域和存储桶名称、地域，然后直接通过这个脚本进行部署。你需要先安装好 [TCCLI](https://cloud.tencent.com/document/product/440/34011) 和 [COSCMD](https://cloud.tencent.com/document/product/436/10976) 并为其配置同一个账户（子用户请注意权限分配）。你还需要保证所提供的函数和存储桶已经创建，且函数的运行时为 CustomRuntime。

*如果你选择通过 COSCMD 和 TCCLI 部署，则需要手动配置 API 网关触发器。*

## 快捷命令

本项目通过 `npm run` 设置了一些快捷命令，可以简化打包和部署所使用的命令：

- `npm run test`：运行单元测试
- `npm run build`：在 SCF 环境下打包
- `npm run deploy`：通过 COSCMD 和 TCCLI 部署
- `npm run sls:deploy` / `npm run serverless:deploy`：通过 Serverless Framework 部署
- `npm run sls:remove` / `npm run serverless:remove`：通过 Serverless Framework 移除

## Swift 云函数项目建议

- 尽管 Swift 可以优雅地处理路径判断，我们仍然不建议将过多的项目合并，否则可能使项目代码混乱。不同的输入结构应该使用不同的函数，以最大程度利用 Swift 的泛型特性和 `Codable` 机制。
- 对于多个 API 路径合并在同一个 Swift 云函数的情况，可以只配置路径为 `/`、方法为 `ANY` 的一个 API 入口，也可以将每个 API 单独配置。
- Swift 云函数中，种类不同的错误应该定义不同的 `Error` 类型，也应该尽可能多、尽可能准确地提供相关信息，方便追踪错误。
