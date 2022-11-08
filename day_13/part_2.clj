(defn fold-about [coord fold]
  (let [axis (first fold) line (second fold) x (first coord) y (second coord)]
    (cond
      (and (= axis :x) (> x line)) (vector (- line (- x line)) y)
      (and (= axis :y) (> y line)) (vector x (- line (- y line)))
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

(def final-coords (reduce #(fold-coords %1 %2) pairs folds))

(def grid (let [max-x (+ (apply max (map first final-coords)) 1)
                max-y (+ (apply max (map second final-coords)) 1)]
            (make-array Boolean/TYPE max-y max-x)))

(run! #(aset grid (second %) (first %) true) final-coords)
(defn row-to-str [r]
  (apply str (map #(if (aget grid r %) "#" ".")
                  (range (count (aget grid r))))))

(run! println (map #(row-to-str %) (range (count grid))))
