﻿#Область ПрограммныйИнтерфейс

// Процедура вызывается при изменении статуса отправки (сдачи) документа.
//
// Параметры:
//	Ссылка - ссылка на документ.
//	СтатусОтправки - ПеречислениеСсылка.СтатусыОтправки - актуальный статус
//
Процедура ПриИзмененииСтатусаОтправкиДокумента(Ссылка, СтатусОтправки) Экспорт
	
КонецПроцедуры

// Вызывается после расшифровки всех файлов транспортного контейнера, или в случае ошибки расшифровки.
// 
// Параметры: см. описание функции УниверсальныйОбменСБанкамиПереопределяемый.ПриРасшифровкеТранзакции.
Процедура ПриРасшифровкеТранзакции(Транзакция, Результат) Экспорт

	УниверсальныйОбменСБанками.ПриРасшифровкеТранзакции(Транзакция, Результат);
	
КонецПроцедуры

#КонецОбласти 

