using System.Web;
using System.Web.Optimization;

namespace Domain.Presentation
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/Content/MainJS").Include(
                        "~/Content/AdminBSB/js/jquery.min.js",
                        "~/Content/AdminBSB/js/bootstrap.min.js",
                        "~/Content/AdminBSB/js/bootstrap-select.min.js",
                        "~/Content/AdminBSB/js/waves.min.js",
                        "~/Content/AdminBSB/js/jquery.dataTables.js",
                        "~/Content/AdminBSB/js/dataTables.bootstrap.min.js",
                        "~/Content/AdminBSB/js/sweetalert.min.js",
                        "~/Content/AdminBSB/js/bootstrap-datepicker.min.js",
                        "~/Content/AdminBSB/js/jquery.countTo.js",
                        "~/Content/AdminBSB/js/Chart.bundle.min.js",
                        "~/Content/AdminBSB/js/autosize.min.js",
                        "~/Content/AdminBSB/js/dropzone.js",
                        "~/Content/AdminBSB/js/admin.js"));

            bundles.Add(new ScriptBundle("~/Content/ValidateJS").Include(
                        "~/Content/AdminBSB/js/jquery.validate.js",
                        "~/Content/AdminBSB/js/form-validation.js"));

            bundles.Add(new ScriptBundle("~/Content/CommonJS").Include(
                        "~/Scripts/Common/common.js"));

            bundles.Add(new ScriptBundle("~/Content/ExtensionsDatatableJS").Include(
                        "~/Content/AdminBSB/js/dataTables.buttons.min.js",
                        "~/Content/AdminBSB/js/buttons.flash.min.js",
                        "~/Content/AdminBSB/js/jszip.min.js",
                        "~/Content/AdminBSB/js/pdfmake.min.js",
                        "~/Content/AdminBSB/js/vfs_fonts.js",
                        "~/Content/AdminBSB/js/buttons.html5.min.js",
                        "~/Content/AdminBSB/js/buttons.print.min.js",
                        "~/Content/AdminBSB/js/jquery-datatable.js",
                        "~/Content/AdminBSB/js/basic-form-elements.js"));

            bundles.Add(new ScriptBundle("~/Content/VueJS").Include(
                        "~/Scripts/Vue/vue.min.js",
                        "~/Scripts/Vue/vee-validate.js",
                        "~/Scripts/Vue/axios.min.js",
                        "~/Scripts/Vue/vuejs-datepicker.min.js"));

            bundles.Add(new StyleBundle("~/Content/MainCSS")
                        .Include("~/Content/AdminBSB/css/fontGoogle.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/iconGoogle.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/bootstrap.min.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/dataTables.bootstrap.min.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/style.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/all-themes.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/materialize.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/bootstrap-datepicker.min.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/dropzone.css", new CssRewriteUrlTransform())
                        .Include("~/Content/AdminBSB/css/sweetalert.css", new CssRewriteUrlTransform()));
        }
    }
}
