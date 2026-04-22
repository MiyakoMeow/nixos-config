{ pkgs, ... }:
{
  # ================ Python 核心环境 ================
  environment.systemPackages = with pkgs; [
    (python3.withPackages (
      ps: with ps; [
        # 基础工具链
        pip
        virtualenv
        setuptools
        wheel

        # 科学计算基础库
        numpy
        scipy
        pandas
        matplotlib
        scikit-learn
        jupyterlab

        # 网络库
        requests
        httpx
        aiohttp
        fastapi
        uvicorn
        sqlalchemy

        # 数据库适配器
        psycopg2
        pgcli
        pglast
        #pgsanity

        # API
        openai

        # 其他
        openpyxl
      ]
    ))
    # 包管理
    poetry
    pipx
    uv
  ];
}
