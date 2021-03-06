default: deploy

deploy:
	s3cmd sync ./ s3://talks.phil.tech \
		--delete-removed --follow-symlinks -P -M \
		--progress --human-readable-sizes --verbose \
		--exclude=.git/* \
		--exclude=node_modules/* \
		--cache-file=.s3-cache \
		--host-bucket=talks.phil.tech

wipe-cache:
	rm .s3-cache

retry: wipe-cache deploy
