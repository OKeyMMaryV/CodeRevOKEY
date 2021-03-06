#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мКоличествоСубконтоМУ Экспорт; // Хранит количество субконто международного учета в документа.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Организация = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("ОсновнаяОрганизация");
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ЭтотОбъект.ДополнительныеСвойства);
    
    // Если это установка/снятие пометки удаления, тогда.
    Если Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
        Возврат;
    КонецЕсли;
	
	ОсновнойСчетЗатрат  = Неопределено;
	ОсновнойСубконто1 	= Неопределено;
	ОсновнойСубконто2 	= Неопределено;
	ОсновнойСубконто3 	= Неопределено;
	ОсновнойСубконто4 	= Неопределено;
	
	НайденнаяСтрока = Способы.Найти(Истина, "Основной");
	
	Если НЕ НайденнаяСтрока = Неопределено Тогда
		ОсновнойСчетЗатрат 	= НайденнаяСтрока.СчетЗатрат;
		ОсновнойСубконто1 	= НайденнаяСтрока.Субконто1;
		ОсновнойСубконто2 	= НайденнаяСтрока.Субконто2;
		ОсновнойСубконто3 	= НайденнаяСтрока.Субконто3;
		ОсновнойСубконто4 	= НайденнаяСтрока.Субконто4;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ЭтотОбъект.ДополнительныеСвойства, Метаданные().ПолноеИмя());
		
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Область ОператорыОсновнойПрограммы

мКоличествоСубконтоМУ = 4;

#КонецОбласти

#КонецЕсли
