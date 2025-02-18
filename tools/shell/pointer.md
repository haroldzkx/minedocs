[批量删除文件](./remove.md)

[批量压缩视频](./zip_vedio.md)

[批量重命名文件](./rename.md)

[处理 PDF 文件](./pdf.md)

[模拟扫码登录 BiliBili](./bilibili_login.md)

[自动化录屏脚本](./record.md)

[Python解析Email文件](./parse_email.md)

[一键安装配置 debian.base](./debian.base.sh)

[一键安装配置 debian.docker](./debian.docker.sh)

# ParsePaper

```python
from parsel import Selector
import pandas as pd


def data_loader(source_file: str):
    with open(source_file, "r", encoding='utf-8') as f:
        return f.read()


def parse_data(filepath: str) -> list:
    selector = Selector(text=data_loader(source_file=filepath))
    papers = selector.css(".gsc_a_tr")

    title_rule = "./td/a/text()"
    year_rule = "./td[last()]/span/text()"
    author_rule = "./td/div[@class='gs_gray']/text()"
    link_rule = "./td/a/@href"
    # conference_rule = ""

    mydata = []

    for single_paper in papers:
        title = single_paper.xpath(title_rule).get()
        year = single_paper.xpath(year_rule).get()
        authors = single_paper.xpath(author_rule).get()
        link = single_paper.xpath(link_rule).get()

        testtt = Paper(title, int(year), authors, link)

        # title = selector.xpath("//tr/td/a[@class='gsc_a_at']/text()").getall()
        # year = selector.xpath("//tr/td[@class='gsc_a_y']/span/text()").getall()
        # authors = selector.xpath("//tr/td/div[position()<2]/text()").getall()
        # link = selector.xpath("//tr/td/a[@class='gsc_a_at']//@href").getall()

        mydata.append(testtt.to_row())
    return mydata


def store_data(path: str, result: list) -> None:
    df = pd.DataFrame(result)
    df.to_excel(path, index=False, header=None)


class Paper:

    def __init__(self, title: str, year: int, authors: str, link: str):
        # def __init__(self, title: str, year: int, authors: str, link: str, conference: str) -> None:
        self.title = title
        self.year = year
        self.authors = authors
        self.link = link
        # self.conference = conference

    def to_row(self) -> list:
        return [self.year, self.title, self.authors, self.link]


if __name__ == "__main__":
    FILE_PATH = "../../Downloads/HuiXiong.html"
    STORE_PATH = "./temp/output.xlsx"
    paper_result = parse_data(filepath=FILE_PATH)
    store_data(path=STORE_PATH, result=paper_result)
    print(f"{'#' * 20} end {'#' * 20}")
```
