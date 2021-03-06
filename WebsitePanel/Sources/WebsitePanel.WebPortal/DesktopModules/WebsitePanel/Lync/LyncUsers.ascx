﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncUsers.ascx.cs" Inherits="WebsitePanel.Portal.Lync.LyncUsers" %>
<%@ Register Src="../ExchangeServer/UserControls/UserSelector.ascx" TagName="UserSelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server" />

<div id="ExchangeContainer">
    <div class="Module">
		<div class="Left">
		</div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="LyncUser" runat="server" />
                    <asp:Localize ID="locTitle" meta:resourcekey="locTitle" runat="server" Text="Lync Users"></asp:Localize>
                </div>
                <div class="FormBody">
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
                    <div class="FormButtonsBarClean">
                        <div class="FormButtonsBarCleanLeft">
                            <asp:Button ID="btnCreateUser" runat="server" meta:resourcekey="btnCreateUser" Text="Create New User"
                                CssClass="Button1" OnClick="btnCreateUser_Click" />
                        </div>
                        <div class="FormButtonsBarCleanRight">
                            <asp:Panel ID="SearchPanel" runat="server" DefaultButton="cmdSearch">
                                <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="True"    
                                onselectedindexchanged="ddlPageSize_SelectedIndexChanged">   
                                    <asp:ListItem>10</asp:ListItem>   
                                    <asp:ListItem Selected="True">20</asp:ListItem>   
                                    <asp:ListItem>50</asp:ListItem>   
                                    <asp:ListItem>100</asp:ListItem>   
                                </asp:DropDownList> 

                                <asp:DropDownList ID="ddlSearchColumn" runat="server" CssClass="NormalTextBox">
                                    <asp:ListItem Value="DisplayName" meta:resourcekey="ddlSearchColumnDisplayName">DisplayName</asp:ListItem>
                                    <asp:ListItem Value="UserPrincipalName" meta:resourcekey="ddlSearchColumnUserPrincipalName">Email</asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox ID="txtSearchValue" runat="server" CssClass="NormalTextBox" Width="100"></asp:TextBox><asp:ImageButton
                                    ID="cmdSearch" runat="server" meta:resourcekey="cmdSearch" SkinID="SearchButton"
                                    CausesValidation="false" />
                            </asp:Panel>
                        </div>
                    </div>

                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" EnableViewState="true"
                        Width="100%" DataSourceID="odsAccountsPaged" EmptyDataText="gvUsers" CssSelectorClass="NormalGridView"
                        meta:resourcekey="gvUsers" AllowPaging="true" AllowSorting="true" OnRowCommand="gvUsers_RowCommand" PageSize="20">
                        <Columns>
                            <asp:TemplateField HeaderText="gvUsersDisplayName" meta:resourcekey="gvUsersDisplayName"
                                SortExpression="DisplayName">
                                <ItemStyle Width="50%"></ItemStyle>
                                <ItemTemplate>
                                    <asp:Image ID="img1" runat="server" ImageUrl='<%# GetAccountImage() %>' ImageAlign="AbsMiddle" />
                                    <asp:HyperLink ID="lnk1" runat="server" NavigateUrl='<%# GetUserEditUrl(Eval("AccountId").ToString()) %>'> 
									<%# Eval("DisplayName") %>
                                    </asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
						    <asp:TemplateField HeaderText="gvUsersLogin" SortExpression="UserPrincipalName">
							    <ItemStyle ></ItemStyle>
							    <ItemTemplate>							        
								    <asp:hyperlink id="lnk2" runat="server"
									    NavigateUrl='<%# GetOrganizationUserEditUrl(Eval("AccountId").ToString()) %>'>
									    <%# Eval("UserPrincipalName") %>
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:BoundField HeaderText="gvUsersEmail" meta:resourcekey="gvUsersEmail" DataField="SipAddress" SortExpression="SipAddress" ItemStyle-Width="25%" />
                            <asp:BoundField HeaderText="gvLyncUserPlan" meta:resourcekey="gvLyncUserPlan" DataField="LyncUserPlanName" SortExpression="LyncUserPlanName" ItemStyle-Width="25%" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:ImageButton ID="cmdDelete" runat="server" SkinID="ExchangeDelete"
                                        CommandName="DeleteItem" CommandArgument='<%# Eval("AccountId") %>' meta:resourcekey="cmdDelete"
                                        OnClientClick="return confirm('Remove this item?');"></asp:ImageButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="odsAccountsPaged" runat="server" EnablePaging="True" SelectCountMethod="GetLyncUsersPagedCount"
                        SelectMethod="GetLyncUsersPaged" SortParameterName="sortColumn" TypeName="WebsitePanel.Portal.LyncHelper">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="itemId" QueryStringField="ItemID" DefaultValue="0" />
                            <asp:ControlParameter Name="filterColumn" ControlID="ddlSearchColumn" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <br />
                    <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Total Users Created:"></asp:Localize>
                    &nbsp;&nbsp;&nbsp;
                    <wsp:QuotaViewer ID="usersQuota" runat="server" QuotaTypeId="2" />
                </div>
            </div>
        </div>
    </div>
</div>
