name: YT-AT build
on:
  schedule:
    - cron: '30 23 */2 * *'
  workflow_dispatch:
    inputs:
      VERSION:
        description: 'Example: 19.47.53'
        required: false
        default: 'Auto'
      DEVICE:
        description: 'Select device'
        required: false
        default: 'arm64-v8a'
        type: choice
        options:
          - armeabi-v7a
          - arm64-v8a
          - x86
          - x86_64
      CLI:
        description: 'Tool cli'
        required: false
        default: 'revanced/revanced-cli'
      PATCH:
        description: 'Tool patch'
        required: false
        default: 'revanced/revanced-patches'
      FEATURE:
        description: 'Turn on/off feature on: [-e "feature"], off: [-d "feature"]'
        required: false
        default: ''
permissions: write-all
env:
    GH_TOKEN: ${{ github.token }}
    VERSION: ${{ inputs.VERSION }}
    DEVICE: ${{ inputs.DEVICE }}
    GITPCLI: ${{ inputs.CLI }}
    GITPATCH: ${{ inputs.PATCH }}
    FEATURE: ${{ inputs.FEATURE }}
jobs:
  build1:
    name: 'Buid Root'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: See build
        env:
          TYPE: 'true'
        run: |
          # kakathic
          [ "$VERSION" ] || VERSION="Auto"
          [ "$DEVICE" ] || DEVICE="arm64-v8a"
          [ "$GITPCLI" ] || GITPCLI="revanced/revanced-cli"
          [ "$GITPATCH" ] || GITPATCH="revanced/revanced-patches"
          [ "$TYPE" ] || TYPE="true"
          . .github/build.sh
      - name: Upload File
        uses: svenstaro/upload-release-action@v2
        with:
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          asset_name: "YT-RE ${{ env.VER }} ${{ env.V }}"
          tag: "K${{ env.V }}${{ env.VER }}"
          overwrite: true
          file: Up
          body: "${{ env.BODYSS }}"
      - name: Upload Json
        uses: svenstaro/upload-release-action@v2
        with:
          asset_name: "Update"
          tag: "Up"
          file: Up*.json
          overwrite: true
          prerelease: true
  build2:
    name: 'Buid No-root'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: See build
        env:
          TYPE: 'false'
        run: |
          # kakathic
          [ "$VERSION" ] || VERSION="Auto"
          [ "$DEVICE" ] || DEVICE="arm64-v8a"
          [ "$GITPCLI" ] || GITPCLI="revanced/revanced-cli"
          [ "$GITPATCH" ] || GITPATCH="revanced/revanced-patches"
          [ "$TYPE" ] || TYPE="false"
          . .github/build.sh
      - name: Upload File
        uses: svenstaro/upload-release-action@v2
        with:
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          asset_name: "YT-RE ${{ env.VER }} ${{ env.V }}"
          tag: "K${{ env.V }}${{ env.VER }}"
          overwrite: true
          file: Up
  build3:
    name: 'Buid Amoled Root'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: See build
        env:
          TYPE: 'true'
          AMOLED: 'true'
        run: |
          # kakathic
          [ "$VERSION" ] || VERSION="Auto"
          [ "$DEVICE" ] || DEVICE="arm64-v8a"
          [ "$GITPCLI" ] || GITPCLI="revanced/revanced-cli"
          [ "$GITPATCH" ] || GITPATCH="revanced/revanced-patches"
          [ "$TYPE" ] || TYPE="true"
          [ "$AMOLED" ] || AMOLED="true"
          . .github/build.sh
      - name: Upload File
        uses: svenstaro/upload-release-action@v2
        with:
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          asset_name: "YT-RE ${{ env.VER }} ${{ env.V }}"
          tag: "K${{ env.V }}${{ env.VER }}"
          overwrite: true
          file: Up
      - name: Upload Json
        uses: svenstaro/upload-release-action@v2
        with:
          asset_name: "Update"
          tag: "Up"
          file: Up*.json
          overwrite: true
          prerelease: true
  build4:
    name: 'Buid Amoled No-root'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: See build
        env:
          TYPE: 'false'
          AMOLED: 'true'
        run: |
          # kakathic
          [ "$VERSION" ] || VERSION="Auto"
          [ "$DEVICE" ] || DEVICE="arm64-v8a"
          [ "$GITPCLI" ] || GITPCLI="revanced/revanced-cli"
          [ "$GITPATCH" ] || GITPATCH="revanced/revanced-patches"
          [ "$TYPE" ] || TYPE="false"
          [ "$AMOLED" ] || AMOLED="true"
          . .github/build.sh
      - name: Upload File
        uses: svenstaro/upload-release-action@v2
        with:
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          asset_name: "YT-RE ${{ env.VER }} ${{ env.V }}"
          tag: "K${{ env.V }}${{ env.VER }}"
          overwrite: true
          file: Up
