(defn fold-about [coord fold]
  (let [axis (first fold) line (second fold) x (first coord) y (second coord)]
    (cond
      (and (= axis :x) (< x line)) (vector (- line (- x line)) y)
      (and (= axis :y) (< y line)) (vector x (- line (- y line)))
      :else (vector x y))))

(defn fold-coords [coords fold]
  (set (map #(fold-about % fold) coords)))

(def lines (line-seq (java.io.BufferedReader. *in*)))
(def split-lines (split-with #(not (empty? %)) lines))

(def pairs (map #(map (fn [x] (Integer/parseInt x))
                      (clojure.string/split % #","))
                (nth split-lines 0)))

(def folds (map #(vector (if (re-find #"x=" %) :x :y)
                         (Integer/parseInt (second (clojure.string/split % #"="))))
                (rest (nth split-lines 1))))

(def one-fold (fold-coords pairs (first folds)))
(println (count one-fold))
