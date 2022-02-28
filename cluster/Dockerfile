FROM msoap/shell2http
RUN apk add --no-cache git cloc
EXPOSE 5000
CMD [ "-port", "5000", "-no-index", "-form", "/gloc", "git clone --depth 1 $v_giturl ./downloaded_code; cloc -json ./downloaded_code | tr -d \" \\n\"; rm -rf ./downloaded_code"]

