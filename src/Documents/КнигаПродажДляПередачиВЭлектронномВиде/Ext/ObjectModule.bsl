﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выгружает документ и возвращает свойства файла выгрузки.
//
// Параметры:
//  УникальныйИдентификатор - адрес во временном хранилище.
//
// Возвращаемое значение:
//  Массив - массив структур. Пустой если не удалось сформировать файл выгрузки. Ключи структуры:
//    * АдресФайлаВыгрузки - адрес двоичных данных файла выгрузки во временном хранилище;
//    * ИмяФайлаВыгрузки - короткое имя файла выгрузки (с расширением).
//
Функция ВыгрузитьДокумент(УникальныйИдентификатор = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	// ОКЕЙ Смирнов М.В. (СофтЛаб) Начало 2021-09-09 (#4347)
	//Если НалоговыйПериод >= '2019-01-01' Тогда
	//	Результат = УчетНДСФормированиеОтчетности.ЭлектронноеПредставлениеКнигиПродаж_504(ЭтотОбъект);
	Если НалоговыйПериод >= '2021-07-01' Тогда
		Результат = УчетНДСФормированиеОтчетности.ЭлектронноеПредставлениеКнигиПродаж_506(ЭтотОбъект);
		
	ИначеЕсли НалоговыйПериод >= '2019-01-01' Тогда
		Результат = УчетНДСФормированиеОтчетности.ЭлектронноеПредставлениеКнигиПродаж_504(ЭтотОбъект);
	// ОКЕЙ Смирнов М.В. (СофтЛаб) Конец 2021-09-09 (#4347)	
	ИначеЕсли НалоговыйПериод >= '2017-10-01' Тогда
		Результат = УчетНДСФормированиеОтчетности.ЭлектронноеПредставлениеКнигиПродаж_503(ЭтотОбъект);
		
	ИначеЕсли НалоговыйПериод >= '2014-10-01' Тогда
		Результат = УчетНДСФормированиеОтчетности.ЭлектронноеПредставлениеКнигиПродаж_502(ЭтотОбъект);
		
	Иначе
		Результат = УчетНДСФормированиеОтчетности.ЭлектронноеПредставлениеКнигиПродаж_501(ЭтотОбъект);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда 
		НалоговыйПериод = НачалоКвартала(Дата);
	КонецЕсли;
	ПериодПоСКНП = УчетНДСКлиентСервер.ПолучитьКодПоСКНП(НалоговыйПериод, Реорганизация);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	НалоговыйПериод		= НачалоКвартала(НалоговыйПериод);
	ПериодСоставления	= НалоговыйПериод;
	РассчитатьСуммыДокумента();
	
	НайденныеДокументы	= Документы.КнигаПродажДляПередачиВЭлектронномВиде.НайтиДокументыЗаНалоговыйПериод(Организация, НалоговыйПериод);
	Если НЕ НайденныеДокументы = Неопределено Тогда
		
		Для каждого Документ Из НайденныеДокументы Цикл
			
			Если НЕ Документ = Ссылка Тогда
				ТекстСообщения	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Уже имеется оформленная книга продаж за %1'"),
					ПредставлениеПериода(НачалоКвартала(НалоговыйПериод), КонецКвартала(НалоговыйПериод), "ФП = Истина"));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Документ, , , Отказ);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("АдресДанныхДляПередачи") Тогда 

		ДанныеДляПередачи 	= ПолучитьИзВременногоХранилища(ДополнительныеСвойства.АдресДанныхДляПередачи);
		РазделыОтчета		= ПроверкаКонтрагентов.РазделыОтчета(ДанныеДляПередачи);
		
		Если РазделыОтчета.Количество() > 0 Тогда
			ПредставлениеОтчета = РазделыОтчета[0].ХранилищеОтчета;
		Иначе
			ПредставлениеОтчета = Неопределено;
		КонецЕсли;
		
		СтруктураДанныхОтчета = Новый Структура("ОбщиеСведения, Записи");
		ЗаполнитьЗначенияСвойств(СтруктураДанныхОтчета, ДанныеДляПередачи);
		ДанныеОтчета = Новый ХранилищеЗначения(СтруктураДанныхОтчета);
		
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата			= НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	НалоговыйПериод	= НачалоКвартала(Дата); 
	Ответственный	= Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьСуммыДокумента()
	
	ВсегоПродаж       = ТабличнаяЧасть.Итог("ВсегоПродаж");
	СуммаБезНДС18     = ТабличнаяЧасть.Итог("СуммаБезНДС18");
	НДС18             = ТабличнаяЧасть.Итог("НДС18");
	СуммаБезНДС10     = ТабличнаяЧасть.Итог("СуммаБезНДС10");
	НДС10             = ТабличнаяЧасть.Итог("НДС10");
	НДС0              = ТабличнаяЧасть.Итог("НДС0");
	СуммаБезНДС20     = ТабличнаяЧасть.Итог("СуммаБезНДС20");
	НДС20             = ТабличнаяЧасть.Итог("НДС20");
	СуммаСовсемБезНДС = ТабличнаяЧасть.Итог("СуммаСовсемБезНДС");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли