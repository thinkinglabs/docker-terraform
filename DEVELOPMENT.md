# Development Guidelines

## Publishing a new Docker image

Modify `TF_VERSION` in the `Dockerfile`.

Commit to git and tag it with the version of Terraform.

```bash
git tag v${TF_VERSION}
git push origin main
git push origin v${TF_VERSION}
```

Both the commit and the tag are pushed and the Github Actions workflow will kick in to publish the Docker image to GitHub packages.
