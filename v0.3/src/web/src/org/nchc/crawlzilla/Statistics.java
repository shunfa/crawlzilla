/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @guide
 * the sevlet for showing information of the nutch crawling data 
 * @web
 * http://code.google.com/p/crawlzilla 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 */
package org.nchc.crawlzilla;/**

 * 首先會進行資料設定，dataInfo.setDataInfo(Index_Dir_Path, Url_Path);
 * 讓DataInfoBean 內的成員有資料，然後把回應結果導向 statistics.jsp
 * 
 * @web
 * <a href="http://code.google.com/p/crawlzilla/">http://code.google.com/p/crawlzilla </a>
 * 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 * 
 */
import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Statistics extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		// 下面兩行讓中文字能正確顯示
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");

		// 建立session
		HttpSession session = request.getSession();

		// 設定nutchdb路徑
		String Index_Dir_Path;
		String Url_Path;
		String archieve_dir = "/home/crawler/crawlzilla/archieve/";
		String def_search_dir = "/home/crawler/crawlzilla/search";
		DataInfoBean dataInfo = new DataInfoBean();
		NutchDBNumBean dbnum = new NutchDBNumBean();
		String name = request.getParameter("fileName");
		if (name == null) {
			Index_Dir_Path = def_search_dir + "/index";
			Url_Path = def_search_dir + "/urls/urls.txt";
		} else {
			Index_Dir_Path = archieve_dir+name.trim()+"/index";
			Url_Path = archieve_dir+name.trim()+ "/urls/urls.txt";
		}
		dbnum.setNum(archieve_dir);
		if (dbnum.getNum() == 0) {
			// target 內沒有資料
			// DBstatus = 1 代表無資料
			dataInfo.setDBstatus(1);
		} else {
			// target 內有資料
			try {
				dataInfo.setDataInfo(Index_Dir_Path.trim(), Url_Path.trim());
			} catch (Exception e) {
				dataInfo.setDBstatus(2);
//				e.printStackTrace();
			}
		}
		session.setAttribute("dataInfo", dataInfo);

		// 前往指定的網頁
		RequestDispatcher rd;
//		rd = getServletContext().getRequestDispatcher("/statistics.jsp");
		rd = getServletContext().getRequestDispatcher("/nutch_DB.jsp");
		rd.forward(request, response);
	}
}