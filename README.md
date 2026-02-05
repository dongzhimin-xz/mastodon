## 此分支为本站魔改分支，欢迎各位站长参考使用
本长毛象实例的网址可能因故变动，目前（2025.11.22）截止笔者编写此文档时，为 https://cmx.xuzhou-jiang.su
本站魔改历程和心得记录于 https://blog.xuzhou-jiang.su
### 本代码使用方法

#### 新建实例
1. 参考[官方文档](https://docs.joinmastodon.org)，您需要自行准备：**域名**（必需）、smtp服务器、存储桶、**运行本代码的服务器**（必需）。
2. 参考[官方文档](https://docs.joinmastodon.org/admin/install/)，安装Ubuntu系统（可以正常运行ruby和其他依赖的Linux系统也可），配置防火墙。依据官方文档安装依赖软件，创建用户`mastodon`。
3. 执行`git clone https://github.com/dongzhimin-xz/mastodon.git live && cd live`，克隆本代码而非官方稳定版代码。`checkout`到你想要的提交版本，一般本分支`HEAD`也可使用。（由于本站代码开源，且不盈利，恕不提供技术支持）
4. 执行[官方文档](https://docs.joinmastodon.org/admin/install/)剩余步骤，安装相应版本的ruby、Gem包和模块，完成实例初始化。
5. 获取并安装网站证书

#### 从官方实例迁移而来
1. 登录运行实例的机器，通过fork或添加远程分支等方法，`git fetch`本代码，并检出到相应版本
2. 假设你完全按照[官方文档](https://docs.joinmastodon.org/admin/install/)安装了官方实例，在`mastodon`用户下执行如下命令拉取ruby最新代码
```bash
git -C "$(rbenv root)"/plugins/ruby-build pull
```
3. 升级ruby，以`mastodon`身份在长毛象目录下执行 `RUBY_CONFIGURE_OPTS=--with-jemalloc rbenv install`
4. 安装依赖包`bundle install`和`yarn install --immutable`
5. 预编译资产`RAILS_ENV=production bundle exec rails assets:precompile`
6. 停止长毛象进程，以`root`身份执行`systemctl stop mastodon-*`
7. 迁移数据库，以`mastodon`身份，回到`/home/mastodon/live`，执行`RAILS_ENV=production bundle exec rails db:migrate`
8. 成功后，启动长毛象进程`systemctl start mastodon-*`

#### 迁移回官方实例
操作类似以上描述

#### 迁移往glitch分支或其他分支
截止目前（2025.11.22以前的提交），未魔改数据库。可以参考相应长毛象版本的文档进行迁移。

未来可能会轻微改动数据库，还望谨慎迁移。

# 任何疑问请阅读官方文档↓↓

> [!NOTE]
> Want to learn more about Mastodon?
> Click below to find out more in a video.

<p align="center">
  <a style="text-decoration:none" href="https://www.youtube.com/watch?v=IPSbNdBmWKE">
    <img alt="Mastodon hero image" src="https://github.com/user-attachments/assets/ef53f5e9-c0d8-484d-9f53-00efdebb92c3" />
  </a>
</p>

<p align="center">
  <a style="text-decoration:none" href="https://github.com/mastodon/mastodon/releases">
    <img src="https://img.shields.io/github/release/mastodon/mastodon.svg" alt="Release" /></a>
  <a style="text-decoration:none" href="https://github.com/mastodon/mastodon/actions/workflows/test-ruby.yml">
    <img src="https://github.com/mastodon/mastodon/actions/workflows/test-ruby.yml/badge.svg" alt="Ruby Testing" /></a>
  <a style="text-decoration:none" href="https://crowdin.com/project/mastodon">
    <img src="https://d322cqt584bo4o.cloudfront.net/mastodon/localized.svg" alt="Crowdin" /></a>
</p>

Mastodon is a **free, open-source social network server** based on [ActivityPub](https://www.w3.org/TR/activitypub/) where users can follow friends and discover new ones. On Mastodon, users can publish anything they want: links, pictures, text, and video. All Mastodon servers are interoperable as a federated network (users on one server can seamlessly communicate with users from another one, including non-Mastodon software that implements ActivityPub!)

## Navigation

- [Project homepage 🐘](https://joinmastodon.org)
- [Donate to support development 🎁](https://joinmastodon.org/sponsors#donate)
  - [View sponsors](https://joinmastodon.org/sponsors)
- [Blog 📰](https://blog.joinmastodon.org)
- [Documentation 📚](https://docs.joinmastodon.org)
- [Official container image 🚢](https://github.com/mastodon/mastodon/pkgs/container/mastodon)

## Features

<img src="./app/javascript/images/elephant_ui_working.svg?raw=true" align="right" width="30%" />

**Part of the Fediverse. Based on open standards, with no vendor lock-in.** - the network goes beyond just Mastodon; anything that implements ActivityPub is part of a broader social network known as [the Fediverse](https://jointhefediverse.net/). You can follow and interact with users on other servers (including those running different software), and they can follow you back.

**Real-time, chronological timeline updates** - updates of people you're following appear in real-time in the UI.

**Media attachments** - upload and view images and videos attached to the updates. Videos with no audio track are treated like animated GIFs; normal videos loop continuously.

**Safety and moderation tools** - Mastodon includes private posts, locked accounts, phrase filtering, muting, blocking, and many other features, along with a reporting and moderation system.

**OAuth2 and a straightforward REST API** - Mastodon acts as an OAuth2 provider, and third party apps can use the REST and Streaming APIs. This results in a [rich app ecosystem](https://joinmastodon.org/apps) with a variety of choices!

## Deployment

### Tech stack

- [Ruby on Rails](https://github.com/rails/rails) powers the REST API and other web pages.
- [PostgreSQL](https://www.postgresql.org/) is the main database.
- [Redis](https://redis.io/) and [Sidekiq](https://sidekiq.org/) are used for caching and queueing.
- [Node.js](https://nodejs.org/) powers the streaming API.
- [React.js](https://reactjs.org/) and [Redux](https://redux.js.org/) are used for the dynamic parts of the interface.
- [BrowserStack](https://www.browserstack.com/) supports testing on real devices and browsers. (This project is tested with BrowserStack)
- [Chromatic](https://www.chromatic.com/) provides visual regression testing. (This project is tested with Chromatic)

### Requirements

- **Ruby** 3.2+
- **PostgreSQL** 14+
- **Redis** 7.0+
- **Node.js** 20+

This repository includes deployment configurations for **Docker and docker-compose**, as well as for other environments like Heroku and Scalingo. For Helm charts, reference the [mastodon/chart repository](https://github.com/mastodon/chart). A [**standalone** installation guide](https://docs.joinmastodon.org/admin/install/) is available in the main documentation.

## Contributing

Mastodon is **free, open-source software** licensed under **AGPLv3**. We welcome contributions and help from anyone who wants to improve the project.

You should read the overall [CONTRIBUTING](https://github.com/mastodon/.github/blob/main/CONTRIBUTING.md) guide, which covers our development processes.

You should also read and understand the [CODE OF CONDUCT](https://github.com/mastodon/.github/blob/main/CODE_OF_CONDUCT.md) that enables us to maintain a welcoming and inclusive community. Collaboration begins with mutual respect and understanding.

You can learn about setting up a development environment in the [DEVELOPMENT](docs/DEVELOPMENT.md) documentation.

If you would like to help with translations 🌐 you can do so on [Crowdin](https://crowdin.com/project/mastodon).

## LICENSE

Copyright (c) 2016-2025 Eugen Rochko (+ [`mastodon authors`](AUTHORS.md))

Licensed under GNU Affero General Public License as stated in the [LICENSE](LICENSE):

```text
Copyright (c) 2016-2025 Eugen Rochko & other Mastodon contributors

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with this program. If not, see https://www.gnu.org/licenses/
```
