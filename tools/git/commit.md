# Git 提交规范

良好的 Git 提交日志非常重要，最明显的一点是，它让整个 Git 提交历史的阅读变得非常轻松。

而且规范的 Git 提交历史，还可以直接生成项目发版的 CHANGELOG。

AngularJS 的开发指南中已经对 Git 的提交日志做了明确规范，这种规范几乎适用于所有项目。

## 提交消息格式

每个提交消息都由三部分组成：标题、正文、页脚。

而标题又具有特殊格式，包括：修改类型、影响范围、内容主题。

```bash
修改类型(影响范围): 标题
<--空行-->
[正文]
<--空行-->
[页脚]
```

```bash
feat(jupyter): init and add jupyter

jupyter(foundation, base, minimal) with python 3.8,3.9
```

## 标题

标题是**强制性**的，但标题的**范围是可选的**。

提交消息的任何一行都不能超过 100 个字符！

这是为了让消息在 GitHub 以及各种 Git 工具中都更容易阅读。

### 修改类型

每个类型值都表示了不同的含义，类型值必须是以下的其中一个：

- **feat**：提交新功能
- **fix**：修复了 bug
- **docs**：只修改了文档
- **style**：调整代码格式，未修改代码逻辑（比如修改空格、格式化、缺少分号等）
- **refactor**：代码重构，既没修复 bug 也没有添加新功能
- **perf**：性能优化，提高性能的代码更改
- **test**：添加或修改代码测试
- **chore**：对 构建流程 或 辅助工具 和 依赖库（如文档生成等）的更改

### 影响范围

范围不是固定值，它可以是你提交代码实际影响到的任何内容。

例如 `$location`、`$browser`、`$compile`、`$rootScope`、`ngHref`、`ngClick`、`ngView`等，唯一需要注意的是它必须足够简短。

当修改影响多个范围时，也可以使用 `*`。

### 标题内容

标题是对变更的简明描述：

- 使用祈使句，现在时态：是 `change`不是 `changed`也不是 `changes`
- 不要大写首字母
- 结尾不要使用句号

## 代码回滚

代码回滚比较特殊，如果本次提交是为了恢复到之前的某个提交，那提交消息应该以 `revert:`开头，后跟要恢复到的那个提交的标题。

然后在消息正文中，应该写上 `This reverts commit <hash>`，其中 `<hash>`是要还原的那个提交的 SHA 值。

## 正文

正文是对标题的补充，但它不是必须的。

和标题一样，它也要求使用祈使句且现在时态，正文应该包含更详细的信息，如代码修改的动机，与修改前的代码对比等。

## 页脚

任何 **Breaking Changes（破坏性变更，不向下兼容）** 都应该在页脚中进行说明，它经常也用来引用本次提交解决的 GitHub Issue。

**Breaking Changes** 应该以 `BREAKING CHANGE:`开头，然后紧跟一个空格或两个换行符，其他要求与前面一致。

## 参考链接

[https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.uyo6cb12dt6w](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.uyo6cb12dt6w)

[https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines)

[https://github.com/angular/angular.js/commits/master](https://github.com/angular/angular.js/commits/master)

[https://github.com/semantic-release/semantic-release](https://github.com/semantic-release/semantic-release)

[https://github.com/angular/angular.js/blob/master/CHANGELOG.md](https://github.com/angular/angular.js/blob/master/CHANGELOG.md)

[https://zhuanlan.zhihu.com/p/67804026](https://zhuanlan.zhihu.com/p/67804026)
