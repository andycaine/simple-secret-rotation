STACK_NAME := simple-secret-rotation
SCHEDULE_EXPRESSION ?= rate(1 day)
SECRET_ARN ?= arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret
ASSETS_BUCKET ?= cfn-assets-repository-publicassetsbucket-lyi1yv8zzwxh
VERSION := 1.0.0

.build:
	mkdir -p $@

packaged.yaml: template.yaml
	aws cloudformation package \
		--template-file $< \
		--s3-bucket $(ASSETS_BUCKET) \
		--output-template-file $@

publish: template.yaml
	aws s3 cp $< s3://$(ASSETS_BUCKET)/$(STACK_NAME)-$(VERSION).yaml

deploy: packaged.yaml
	aws cloudformation deploy \
		--template-file $< \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_IAM \
		--parameter-overrides \
			SecretArn=$(SECRET_ARN) \
			ScheduleExpression="$(SCHEDULE_EXPRESSION)"

destroy:
	aws cloudformation delete-stack \
		--stack-name $(STACK_NAME)
	aws cloudformation wait stack-delete-complete \
		--stack-name $(STACK_NAME)

tag:
	git tag -a v$(VERSION) -m "Release $(VERSION)"

release: tag
	git push origin v$(VERSION)
