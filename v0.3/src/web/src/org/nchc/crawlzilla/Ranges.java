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
 * called by IndexInfo
 * @web
 * http://code.google.com/p/crawlzilla 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 */

package org.nchc.crawlzilla;
import org.apache.lucene.util.OpenBitSet;

@SuppressWarnings("serial")
public class Ranges extends OpenBitSet {
  
  public static Ranges parse(String expr) throws Exception {
    Ranges res = new Ranges();
    expr = expr.replaceAll("\\s+", "");
    if (expr.length() == 0) {
      return res;
    }
    String[] ranges = expr.split(",");
    for (int i = 0; i < ranges.length; i++) {
      String[] ft = ranges[i].split("-");
      int from, to;
      from = Integer.parseInt(ft[0]);
      if (ft.length == 1) {
        res.set(from);
      } else {
        to = Integer.parseInt(ft[1]);
        res.set(from, to);
      }
    }
    return res;
  }
  
  public void set(int from, int to) {
    if (from > to) return;
    for (int i = from; i <= to; i++) {
      set(i);
    }
  }
}
