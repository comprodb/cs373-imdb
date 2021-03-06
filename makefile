FILES :=                              \
    .travis.yml                       \
    makefile                          \
    IDB3.log                          \
    models.html                       \
    models.py

check:
	@not_found=0;                                 \
    for i in $(FILES);                            \
    do                                            \
        if [ -e $$i ];                            \
        then                                      \
            echo "$$i found";                     \
        else                                      \
            echo "$$i NOT FOUND";                 \
            not_found=`expr "$$not_found" + "1"`; \
        fi                                        \
    done;                                         \
    if [ $$not_found -ne 0 ];                     \
    then                                          \
        echo "$$not_found failures";              \
        exit 1;                                   \
    fi;                                           \
    echo "success";

.PHONY: clean IDB1.log test

clean:
	rm -f  *.pyc
	sudo rm -rf __pycache__ */__pycache__

config:
	git config -l

scrub:
	make clean

status:
	make clean
	@echo
	git branch
	git remote -v
	git status

test: tests.py
	coverage3 run --branch ./tests.py
	coverage3 report --omit='*/lib/python3.4/*','/lusr/lib/python3.4/*' -m

models.html: models.py
	python -m pydoc -w models

IDB3.log:
	git log > IDB3.log

commit: $(FILES) IDB3.log models.html
	git add IDB1.log models.html
	git commit
