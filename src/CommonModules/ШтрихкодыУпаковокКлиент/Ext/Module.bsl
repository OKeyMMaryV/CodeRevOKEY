﻿
#Область ПрограммныйИнтерфейс

// Выполняет действие печати (например открывает форму обработки печати этикеток и ценников, или выполняет команду печати).
//
// Параметры:
//   ОбъектыПечати - Массив           - массив структур с описанием штрихкода.
//   Форма         - ФормаКлиентскогоПриложения - форма-владелец из которой выполняется печать
//
Процедура ПечатьШтрихкодовУпаковок(ОбъектыПечати, Форма) Экспорт
	
	СтандартнаяОбработка = Истина;
	ШтрихкодыУпаковокКлиентПереопределяемый.ПечатьШтрихкодовУпаковок(ОбъектыПечати, Форма, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		ПараметрКоманды = Новый Массив;
		ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка"));
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("АдресВХранилище"       , ПоместитьВоВременноеХранилище(ОбъектыПечати, Форма.УникальныйИдентификатор));
		ПараметрыПечати.Вставить("КоличествоЭкземпляров" , 1);
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.ГенерацияШтрихкодовУпаковок",
			"ШтрихкодыУпаковокТоваров",
			ПараметрКоманды,
			Форма,
			ПараметрыПечати);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
