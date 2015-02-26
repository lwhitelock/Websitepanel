﻿using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using WebsitePanel.WebDav.Core;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDavPortal.Extensions;
using WebsitePanel.WebDavPortal.UI.Routes;

namespace WebsitePanel.WebDavPortal.FileOperations
{
    public class FileOpenerManager
    {
        private readonly IDictionary<string, FileOpenerType> _operationTypes = new Dictionary<string, FileOpenerType>();

        public FileOpenerManager()
        {
            if (WebDavAppConfigManager.Instance.OfficeOnline.IsEnabled)
                _operationTypes.AddRange(WebDavAppConfigManager.Instance.OfficeOnline.ToDictionary(x => x.Extension, y => FileOpenerType.OfficeOnline));
        }

        public string GetUrl(IHierarchyItem item, UrlHelper urlHelper)
        {
            var opener = this[Path.GetExtension(item.DisplayName)];
            string href = "/";

            switch (opener)
            {
                case FileOpenerType.OfficeOnline:
                {
                    var pathPart = item.Href.AbsolutePath.Replace("/" + WspContext.User.OrganizationId, "").TrimStart('/');
                    href = string.Concat(urlHelper.RouteUrl(FileSystemRouteNames.EditOfficeOnline, new { org = WspContext.User.OrganizationId, pathPart = "" }), pathPart);
                    break;
                }
                default:
                {
                    href = item.Href.LocalPath;
                    break;
                }
            }

            return href;
        }

        public bool GetIsTargetBlank(IHierarchyItem item)
        {
            var opener = this[Path.GetExtension(item.DisplayName)];

            switch (opener)
            {
                case FileOpenerType.OfficeOnline:
                    return true;
                default:
                    return false;
            }
        }

        public FileOpenerType this[string fileExtension]
        {
            get
            {
                FileOpenerType result;
                if (_operationTypes.TryGetValue(fileExtension, out result) && CheckBrowserSupport())
                    return result;
                return FileOpenerType.Download;
            }
        }

        private bool CheckBrowserSupport()
        {
            var request = HttpContext.Current.Request;
            int supportedVersion;

            string key = string.Empty;

            foreach (var supportedKey in WebDavAppConfigManager.Instance.OwaSupportedBrowsers.Keys)
            {
                if (supportedKey.Split(';').Contains(request.Browser.Browser))
                {
                    key = supportedKey;
                    break;
                }
            }

            if (WebDavAppConfigManager.Instance.OwaSupportedBrowsers.TryGetValue(key, out supportedVersion) == false)
            {
                return false;
            }

            return supportedVersion <= request.Browser.MajorVersion;
        }
    }
}