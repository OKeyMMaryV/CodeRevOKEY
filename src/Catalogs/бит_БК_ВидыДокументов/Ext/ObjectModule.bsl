﻿
Процедура ПередЗаписью(Отказ)
	Если НЕ ДокументОплаты и НЕ ЗакрывающийДокумент Тогда 
		Сообщить("Необходимо указать хотя бы один из признаков вида документа: <Документ оплаты> или <Закрывающий документ>");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры
