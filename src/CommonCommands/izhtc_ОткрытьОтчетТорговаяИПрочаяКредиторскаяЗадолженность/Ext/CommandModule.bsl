﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// +СБ Кузнецова С. 2016-07-27 
	//ОК_ОбщегоНазначения.ОткрытьОтчетТорговаяИПрочаяКредиторскаяЗадолженность();
	ИмяОбработки = Неопределено;
	ОткрытьОтчетТорговаяИПрочаяКредиторскаяЗадолженность(ИмяОбработки);
	Если ИмяОбработки <> Неопределено Тогда
		ОткрытьФорму("ВнешнийОтчет."+ ИмяОбработки +".Форма");	
	КонецЕсли;
	// -СБ Кузнецова С.
	//Форма = ПолучитьФорму("Отчет.СБ_ТорговаяИПрочаяКредиторскаяЗадолженность.Форма.ФормаОтчетаУправляемая");	 //ОК Довбешка Т. 01.04.2017
	//Форма.Открыть();
КонецПроцедуры

// +СБ Кузнецова С. 2016-07-27 
&НаСервере
Процедура ОткрытьОтчетТорговаяИПрочаяКредиторскаяЗадолженность(ИмяОбработки) 
	имяотчета_="Торговая и прочая кредиторская задолженность";
	попытка
		ИмяФайла = ПолучитьИмяВременногоФайла("erf");		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДополнительныеОтчетыИОбработки.Ссылка
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
		|ГДЕ
		|	ДополнительныеОтчетыИОбработки.Наименование = &Наименование";
		Запрос.УстановитьПараметр("Наименование", имяотчета_);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Возврат;
		Иначе
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			ОтчетСсылка = Выборка.Ссылка;
		КонецЕсли;
		ИмяОбработки = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ОтчетСсылка);					
	исключение
	конецпопытки;	
КонецПроцедуры
// -СБ Кузнецова С.