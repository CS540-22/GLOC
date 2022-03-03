#!/bin/sh

git clone --depth 1 $1 ./downloaded_code
cloc -json ./downloaded_code | tr -d " \n"
rm -rf ./downloaded_code