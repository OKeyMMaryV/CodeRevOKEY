#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Константы.НеИспользуетсяОСНО.Установить(Не Константы.ИспользуетсяОСНО.Получить());
	
КонецПроцедуры

#КонецЕсли