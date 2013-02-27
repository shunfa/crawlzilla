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
 * called by "IndexInfo"
 * Statistics <-- DataInfoBean <- IndexInfo <- this
 * @web
 * http://code.google.com/p/crawlzilla 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 */
package org.nchc.crawlzilla;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.apache.lucene.index.IndexGate;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.TermEnum;
import org.apache.lucene.index.IndexGate.FormatDetails;
import org.apache.lucene.index.IndexReader.FieldOption;
import org.apache.lucene.store.Directory;

public class IndexInfo {
  private IndexReader reader;
  private Directory dir;
  private String indexPath;
  private long totalFileSize;
  private int numTerms;
  private int indexFormat;
  private FormatDetails formatDetails;
  private TermInfo[] topTerms;
  private List<String> fieldNames;
  private String lastModified;
  private String version;
  private String dirImpl;
  
  public IndexInfo(IndexReader reader, String indexPath) throws Exception {
    this.reader = reader;
    try {
      this.dir = reader.directory();
      this.dirImpl = dir.getClass().getName();
    } catch (UnsupportedOperationException uoe) {
      this.dir = null;
      this.dirImpl = "N/A";
    }
    try {
      this.version = Long.toString(reader.getVersion());
    } catch (UnsupportedOperationException uoe) {
      this.dir = null;      
    }
    this.indexPath = indexPath;
    lastModified = dir == null ? "N/A" : new Date(IndexReader.lastModified(reader.directory())).toString();
    totalFileSize = dir == null ? -1 : Util.calcTotalFileSize(indexPath, reader.directory());
    numTerms = 0;
    TermEnum te = reader.terms();
    while (te.next())
      numTerms++;
    te.close();
    fieldNames = new ArrayList<String>();
    fieldNames.addAll(reader.getFieldNames(FieldOption.ALL));
    Collections.sort(fieldNames);
    if (dir != null) {
      indexFormat = IndexGate.getIndexFormat(dir);
      formatDetails = IndexGate.getFormatDetails(indexFormat);
    } else {
      indexFormat = -1;
      formatDetails = new FormatDetails();
    }
    topTerms = HighFreqTerms.getHighFreqTerms(reader, null, 51, (String[])fieldNames.toArray(new String[fieldNames.size()]));
  }

  /**
   * @return the reader
   */
  public IndexReader getReader() {
    return reader;
  }

  public Directory getDirectory() {
    return dir;
  }
  
  /**
   * @return the indexPath
   */
  public String getIndexPath() {
    return indexPath;
  }

  /**
   * @return the totalFileSize
   */
  public long getTotalFileSize() {
    return totalFileSize;
  }

  /**
   * @return the numTerms
   */
  public int getNumTerms() {
    return numTerms;
  }

  /**
   * @return the indexFormat
   */
  public int getIndexFormat() {
    return indexFormat;
  }

  /**
   * @return the formatDetails
   */
  public FormatDetails getFormatDetails() {
    return formatDetails;
  }

  /**
   * @return the topTerms
   */
  public TermInfo[] getTopTerms() {
    return topTerms;
  }

  /**
   * @return the fieldNames
   */
  public List<String> getFieldNames() {
    return fieldNames;
  }

  /**
   * @return the lastModified
   */
  public String getLastModified() {
    return lastModified;
  }
  
  public String getVersion() {
    return version;
  }
  
  public String getDirImpl() {
    return dirImpl;
  }

}
