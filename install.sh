#!/bin/bash

CHROME_JSON_URL='https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json'

check_prerequisites(){
  for command in "jq" "brew" "curl" "unzip"; do
    if ! command -v $command > /dev/null; then
      echo "$commandがインストールされていません"
      exit 1
    fi
  done
}

copy_file_from_template(){
  if [ -e "man_hours.yml" ]; then
    echo "man_hours.ymlが存在するのでスキップします"
    return
  fi

  echo "テンプレートからファイルをコピーします"
  cp "man_hours_template.yml" "man_hours.yml"
}

install_chrome() {
  if [ -e '.bin/chrome/Google Chrome for Testing.app' ]; then
    echo "Chrome is already installed"
    return
  fi

  url="$(curl -s "${CHROME_JSON_URL}" |
    jq -r '.channels.Stable.downloads.chrome[]|select(.platform == "mac-arm64").url')"
  echo "Downloading Chrome from ${url} ..."
  curl -L "${url}" -o .bin/chrome.zip
  unzip .bin/chrome.zip -d .bin
  mv .bin/chrome-mac-arm64 .bin/chrome
}

bundle_install() {
  bundle install --quiet
}

install_chromedriver() {
  if [ -e '.bin/chromedriver/chromedriver' ]; then
    echo "Chromedriver is already installed"
    return
  fi

  url="$(curl -s "${CHROME_JSON_URL}" |
    jq -r '.channels.Stable.downloads.chromedriver[]|select(.platform == "mac-arm64").url')"
  echo "Downloading Chromedriver from ${url} ..."
  curl -L "${url}" -o .bin/chromedriver.zip
  unzip .bin/chromedriver.zip -d .bin
  mv .bin/chromedriver-mac-arm64 .bin/chromedriver
}

check_prerequisites
copy_file_from_template
bundle_install
install_chrome
install_chromedriver
