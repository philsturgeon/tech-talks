deploy:
	s3cmd sync s3://talks.philsturgeon.uk ./ --delete-removed
