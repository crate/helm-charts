package:
	ls src | xargs -I@ helm package --destination='docs/@' 'src/@'

repo: package
	helm repo index docs
