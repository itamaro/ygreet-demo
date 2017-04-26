BASEDIR=$(CURDIR)
PROJECT_ID=`gcloud config get-value project 2>/dev/null`

all: builders app

clean:
	rm -r $(BASEDIR)/build $(BASEDIR)/yabtwork $(BASEDIR)/ybt_bin

builders: gcloud-docker
	ybt build :builders --project-id $(PROJECT_ID) --build-base-images --push

app: gcloud-docker
	ybt build --project-id $(PROJECT_ID) --push

gcloud-docker:
	gcloud docker -a

.PHONY: clean builders app
