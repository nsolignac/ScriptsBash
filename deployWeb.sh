# RUTAS DE TRABAJO
ROOTDIR="/var/www/multichannelWeb"
PROJECTNAME="mc-web"

# LIMPIEZA
cd $ROOTDIR
rm -r *_* || true

# BACKUP
cp -r js/ js_$(date +%d-%m-%Y) || true
cp -r css/ css_$(date +%d-%m-%Y) || true
cp -r view/ view_$(date +%d-%m-%Y) || true
cp -r i18n/ i18n_$(date +%d-%m-%Y) || true
cp -r img/ img_$(date +%d-%m-%Y) || true
cp index.html index.html_$(date +%d-%m-%Y) || true

# DEPLOY
echo "Se comienza con el DEPLOY"
cp -r ${WORKSPACE}/$PROJECTNAME/js ROOTDIR/js
cp -r ${WORKSPACE}/$PROJECTNAME/css ROOTDIR/css
cp -r ${WORKSPACE}/$PROJECTNAME/view ROOTDIR/view
cp -r ${WORKSPACE}/$PROJECTNAME/i18n ROOTDIR/i18n
cp -r ${WORKSPACE}/$PROJECTNAME/img ROOTDIR/img
cp ${WORKSPACE}/$PROJECTNAME/index.html ROOTDIR/index.html
echo "Se realizo el DEPLOY"

# RESTAURAMOS CONFIG
cp $ROOTDIR/js_$(date +%d-%m-%Y)/config/config.js $ROOTDIR/js/config/config.js

# ACTUALIZAMOS EL index.html
VERSION="        window.APP_VERSION = $(date +%d%m%Y)"
sed -i "13s/.*/${VERSION}/g" index.html

# PERMISOS
echo "Actualizamos los permisos"
# CHOWN
chown -R www-data:www-data $ROOTDIR
# CHMOD
chmod -R 744 $ROOTDIR
chmod -R 777 $ROOTDIR/logs
chmod -R 777 $ROOTDIR/uploads
chmod -R 777 $ROOTDIR/reports
chmod -R 777 $ROOTDIR/logos

# NPM
npm install
