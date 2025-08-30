import pandas as pd

def add_sheet(df, sheet_name, file_path):
    """
    将DataFrame添加到Excel文件的新工作表中
    :param df: 要写入的DataFrame
    :param sheet_name: 工作表名称
    :param file_path: Excel文件路径（不包含扩展名）
    """
    try:
        # 尝试读取已存在的Excel文件
        with pd.ExcelWriter(f"{file_path}.xlsx", mode='a', if_sheet_exists='replace') as writer:
            df.to_excel(writer, sheet_name=sheet_name)
    except FileNotFoundError:
        # 如果文件不存在，创建新文件
        with pd.ExcelWriter(f"{file_path}.xlsx") as writer:
            df.to_excel(writer, sheet_name=sheet_name)