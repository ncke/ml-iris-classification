package com.ncke.kml_knn

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform