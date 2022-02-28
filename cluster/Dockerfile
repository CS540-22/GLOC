FROM msoap/shell2http
RUN apk add --no-cache git cloc
EXPOSE 5000
COPY api/cloc.sh .
CMD [ "-port", "5000", "-no-index", "-form", "/gloc", "./cloc.sh $v_giturl"]