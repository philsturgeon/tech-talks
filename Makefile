default: deploy

deploy:
	s3cmd sync ./ s3://talks.philsturgeon.uk \
		--delete-removed --follow-symlinks --acl-public \
		--progress --human-readable-sizes \
		--exclude=.git/ \
		--exclude=./node_modules/ \
		--cache-file=.s3-cache

wipe-cache:
	rm .s3-cache

retry: wipe-cache deploy
