```python
import pymupdf
from typing import Generator, List
from pathlib import Path
from datetime import datetime


def merge_pdf(
        doc_list: List[str],
        out_pdf: str) -> None:
    count = []
    bookmarks = []
    with pymupdf.open() as target:
        # 将PDF合并
        for doc in doc_list:
            with pymupdf.open(doc) as insert_doc:
                count.append(insert_doc.page_count)
                bookmarks.append(insert_doc.get_toc())
                target.insert_pdf(insert_doc)
        # 合并bookmarks
        try:
            flattened_bookmarks = merge_bookmarks(count, bookmarks)
            target.set_toc(flattened_bookmarks)
        except Exception as e:
            print(f"Error setting bookmarks: {e}")
        target.save(out_pdf)

def delete_pages(
        source_path: str,
        out_pdf: str,
        f_page: int,
        t_page: int) -> None:
    with pymupdf.open(source_path) as doc:
        doc.delete_pages(from_page=f_page-1, to_page=t_page-1)
        doc.save(out_pdf)

def insert_page_with_blank(
        source_pdf: str,
        output_pdf: str,
        page_number: int) -> None:
    with pymupdf.open(source_pdf) as doc:
        doc.new_page(page_number-1, width = 595, height = 842)
        doc.save(output_pdf)

def insert_pages(main_pdf, slave_pdf, output_pdf, pos):
    pos -= 1
    doc_1 = pymupdf.open(main_pdf)
    doc_2 = pymupdf.open(slave_pdf)
    result = pymupdf.open()

    page_1 = [page for page in range(pos)]
    page_3 = [page for page in range(pos, doc_1.page_count)]
    doc_1.select(page_1)
    doc_3 = pymupdf.open(main_pdf)
    doc_3.select(page_3)

    result.insert_pdf(doc_1)
    result.insert_pdf(doc_2)
    result.insert_pdf(doc_3)
    result.save(output_pdf)

    doc_1.close()
    doc_2.close()
    doc_3.close()
    result.close()

def extract_pages(
        source_pdf: str,
        output_pdf: str,
        pages: List[int]) -> None:
    '''
    :params:
        pages = [1, 3, 12, 11]
        pages = [4]
        pages = [x for x in range(4, 10)]
    '''
    pages = [page - 1 for page in pages]
    with pymupdf.open(source_pdf) as doc:
        doc.select(pages)
        doc.save(output_pdf)


def images_to_pdf(image_paths: List[str], output_path: str) -> None:
    pdf = pymupdf.open()
    for image_path in image_paths:
        img = pymupdf.open(image_path)
        pdf_bytes = img.convert_to_pdf()
        img.close()
        img_pdf = pymupdf.open("pdf", pdf_bytes)
        pdf.insert_pdf(img_pdf)
        img_pdf.close()
    pdf.save(output_path)
    pdf.close()

def pdf_to_img(
        source_pdf: str,
        output_img: str,
        type: str,
        dpi: int,
        pages: List[int]) -> None:
    '''
    :params:
        type: jpeg/png/...
        pages = [1, 3, 12, 11] or [4] or [1]
    '''
    doc = pymupdf.open(source_pdf)
    for page_num in pages:
        if page_num <= len(doc):
            page = doc[page_num-1]
            pix = page.get_pixmap(matrix=pymupdf.Matrix(300/72), dpi=dpi)
            output_file = f"{output_img}_{page_num}.{type}"
            pix.save(output_file)
    doc.close()


def find_files_with_extensions(
        directory: str,
        extensions: dict) -> Generator[Path, None, None]:
    path = Path(directory).expanduser()
    for file_path in path.glob("*"):
        if file_path.suffix.lower() in extensions:
            yield file_path  # 使用生成器返回匹配的文件路径

def get_timestamp() -> str:
    now = datetime.now()
    date_string = now.strftime("%Y%m%d")
    time_string = now.strftime("%H%M%S")
    return date_string + "." + time_string

def sort_toc(toc: List[List]) -> List[List]:
    return sorted(toc, key=lambda x: (x[2], -x[3] if len(x) > 3 else float('-inf')))


def delete_by_level(toc: List[List], title: str) -> bool:
    for i in range(len(toc)):
        if toc[i][1] == title:
            level = toc[i][0]
            j = i + 1
            while j < len(toc) and toc[j][0] > level:
                del toc[j]
            del toc[i]
            return True
    return False

def delete_by_title(pdf_source: str, pdf_target: str, titles: list) -> None:
    with pymupdf.open(pdf_source) as doc:
        toc_old = doc.get_toc()

        for title in titles:
            if not delete_by_level(toc_old, title):
                print(f"目录中未找到标题为 '{title}' 的项.")

        doc.set_toc(toc_old)
        doc.save(pdf_target)

def merge_bookmarks(count, bookmarks):
    for i in range(1, len(count)):
        count[i] += count[i-1]
    for i in range(1, len(bookmarks)):
        for item in bookmarks[i]:
            item[2] += count[i-1]
    flattened_bookmarks = [item for sublist in bookmarks for item in sublist]
    return flattened_bookmarks


def add_bookmarks(pdf_source: str, pdf_target: str, new_items: list) -> None:
    with pymupdf.open(pdf_source) as doc:
        toc_old = doc.get_toc()

        for new_item in new_items:
            toc_old.append(new_item)

        toc_new = sort_toc(toc_old)

        doc.set_toc(toc_new)
        doc.save(pdf_target)

def get_bookmarks(source: str) -> List[List]:
    with pymupdf.open(source) as doc:
        toc = doc.get_toc()
        return toc

def main_delete_pages():
    '''Delete Pages'''
    print('\n *** Delete PDF Pages ***')
    # source_path = input(' Please input the PDF path that need delete pages: ')

    # 想删除单个页面时，只需让first_page == end_page就可以
    # first_page和end_page页面编码从1开始
    # print(' Please input the delete Page Number, format as below')
    # print('   - range: 2-10')
    # print('   - single page: 2-2, 3-3.')
    # page_range = input(' Delete pages range: ')
    # pages = page_range.split('-')
    # first_page = int(pages[0])
    # end_page = int(pages[1])

    source_path = '/path/xxx.pdf'
    out_pdf = f'/path/result.{get_timestamp()}.pdf'
    first_page = 1
    end_page = 195
    delete_pages(source_path, out_pdf, f_page=first_page, t_page=end_page)
    print('*** Delete PDF pages SUCCESS ***\n')

def main_insert_pages():
    '''Insert Pages'''
    # 这里有个问题还没解决：目录丢失问题
    print('\n *** Insert PDF Pages ***')
    # source_path = input(' Please input the main PDF path: ')
    # slave_path = input(' Please input the slave PDF path: ')
    # insert_pos = int(input(' Please input the insert position: '))
    source_path = '/path/3.pdf'
    slave_path = '/path/2.pdf'
    insert_pos = 5
    out_pdf = f'/path/result.{get_timestamp()}.pdf'
    insert_pages(source_path, slave_path, out_pdf, insert_pos)
    print('*** Insert PDF pages SUCCESS ***\n')

def main_insert_blank_page():
    '''Insert Pages with Blank'''
    print('\n *** Insert PDF with Blank page ***')
    # source_path = input(' Please input the main PDF path: ')
    # page_number = int(input(' Please input the insert position: '))

    source_path = '/path/1.pdf'
    out_pdf = f'/path/result.{get_timestamp()}.pdf'
    page_number = 3
    insert_page_with_blank(source_path, out_pdf, page_number)
    print('*** Insert PDF pages SUCCESS ***\n')

def main_extract_pages():
    '''Extract Pages'''
    print('\n *** Extract PDF pages form a single PDF ***')
    # source_path = input(' Please input the main PDF path: ')
    source_path = '/path/xxx.pdf'
    out_pdf = f'/path/result.{get_timestamp()}.pdf'
    # pages = [1, 2, 3, 4, 5, 6]
    # pages = [2]
    pages = [x for x in range(166, 196)]
    # print(' Please input the delete Page Number, format as below')
    # print('   1) 2')
    # print('   2) 1,2,4,7,13')
    # input_str = input(" 请输入一组页面编号，用逗号分隔：")
    # pages = [int(x) for x in input_str.split(',')]
    extract_pages(source_path, out_pdf, pages)
    print('*** Extract PDF pages SUCCESS ***\n')

def main_image2pdf():
    '''Convert Images to PDF'''
    print('\n *** Convert Images to PDF ***')
    directory = '/path/te'
    # directory = input(' Please input the directory: ')
    extensions = {'.jpg'}
    # extensions_input = input(' Please input the file type(.png, .jpeg): ')
    # extensions = set(x for x in extensions_input.split())

    doc_list = sorted(find_files_with_extensions(directory, extensions), key=lambda p: p.name)
    out_pdf = f'./result.{get_timestamp()}.pdf'
    images_to_pdf(doc_list, out_pdf)
    print('*** Convert Images to PDF SUCCESS ***\n')

def main_pdf2image():
    '''Convert PDF to Image(jpeg, png, ...)'''
    print('\n *** Convert PDF to Images ***')
    # source_path = input(' Please input the PDF path: ')
    # source_path = '/path/pmpaper1/modelarch.pdf'
    source_path = '/path/pmpaper1/net_policy.pdf'
    # source_path = '/path/pmpaper1/net_value.pdf'
    # out_img = f'/path/result.{get_timestamp()}'
    # out_img = f'/path/net_value'
    out_img = f'/path/net_policy'
    # pages = [1, 3, 4]
    pages = [1]
    # pages = [x for x in range(1, 9)]
    # input_str = input(" 请输入一组页面编号，用逗号分隔：")
    # pages = [int(x) for x in input_str.split(',')]
    # filetype = input(' Please input the images type(png/jpeg): ')
    filetype = 'jpg'
    pdf_to_img(source_path, out_img, filetype, dpi=300, pages=pages)
    print('\n *** Convert PDF to Images SUCCESS ***')

def main_merge_pdf():
    '''Merge PDF list'''
    # 存在目录丢失的问题
    print('\n *** Merge multi PDFs ***')
    directory = "/path"  # 指定目录的路径
    # directory = input(' Please input the PDF path: ')
    extensions = {".pdf"}  # 指定要查找的文件扩展名,{".pdf", ".py", '.txt'}

    out_pdf = f'/Users/xxx/code/pdf/result.{get_timestamp()}.pdf'
    doc_list = sorted(find_files_with_extensions(directory, extensions), key=lambda p: p.name)
    merge_pdf(doc_list=doc_list, out_pdf=out_pdf)
    print('\n *** Merge multi PDFs SUCCESS ***')

def main_bookmarks_add():
    '''Add Bookmarks'''
    pdf_source = './make.pdf'
    pdf_target = './make_new.pdf'

    # [bookmark_level, title_name, page_number, offset]
    new_items = [
        [1, 'Foreword', 5, 150],
        [1, 'This Book', 13, 140],
        [1, 'Idea', 18, 150],
        [1, 'Build', 36, 150],
        [1, 'Launch', 75, 150],
        [1, 'Grow', 113, 150],
        [1, 'Monetize', 130, 150],
        [1, 'Automate', 170, 150],
        [1, 'Exit', 183, 150],
        [1, 'Epilogue', 215, 150]
    ]

    add_bookmarks(pdf_source, pdf_target, new_items)
    print('\n *** Add New Bookmarks SUCCESS ***')

def main_bookmarks_delete_by_title():
    '''Delete Bookmarks by Title'''
    pdf_source = '/path/xxx.pdf'
    pdf_target = '/path/xxx_temp.pdf'

    titles = [
        '3 Convex Methods for Sparse Signal Recovery ',
        '4 Convex Methods for Low-Rank Matrix Recovery ',
        '5 Decomposing Low-Rank and Sparse Matrices ',
        '6 Recovering General Low-Dimensional Models ',
        '7 Nonconvex Methods for Low-Dimensional Models '
    ]

    delete_by_title(pdf_source, pdf_target, titles)
    print('Delete Bookmarks by Title SUCCESS...')

def main_unlock():
    '''Unlock PDF'''
    print(' Unlock PDF SUCCESS...')

def main_protect():
    '''Protect PDF with Password'''
    print(' Protect PDF SUCCESS, Password is 【】...')

if __name__ == '__main__':
    '''PDF page'''
    # main_delete_pages()
    # main_insert_pages()
    # main_insert_blank_page()
    # main_extract_pages()
    main_merge_pdf()

    '''PDF image'''
    # main_image2pdf()
    # main_pdf2image()

    '''PDF bookmarks'''
    # main_bookmarks_add()
    # main_bookmarks_delete_by_title()

    '''PDF file'''
    # main_unlock()
    # main_protect()
```
