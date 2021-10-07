﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта", "Общий");
	
	ФормаОтчета = ПолучитьФорму("Отчет.бит_ИсполнениеДоговоров.Форма"
				,ПараметрыФормы
				,ПараметрыВыполненияКоманды.Источник
				,ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор
				,ПараметрыВыполненияКоманды.Окно);
				
	ФормаОтчета.Отчет.Период.ДатаНачала	   = Дата("00010101");
	ФормаОтчета.Отчет.Период.ДатаОкончания = Дата("00010101");
				
	КомпоновщикНастроек = ФормаОтчета.Отчет.КомпоновщикНастроек;
	
	СтруктураПараметров = ПолучитьПараметрыВОтчет(ПараметрКоманды, КомпоновщикНастроек);
	
	НастройкиКомпоновщика = СтруктураПараметров.НастройкиКомпоновщика;
	
	НастройкиКомпоновщика.Отбор.Элементы.Очистить();
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(НастройкиКомпоновщика.Отбор, Новый ПолеКомпоновкиДанных("ДоговорКонтрагента"), СтруктураПараметров.ДоговорКонтрагента);
	
	ФормаОтчета.Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновщика);
	
	ФормаОтчета.Открыть();
	
	ФормаОтчета.СкомпоноватьРезультат();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция получает настройки компоновщика настроек.
//
&НаСервере
Функция ПолучитьПараметрыВОтчет(ПараметрКоманды, КомпоновщикНастроек)
	
	Структура = Новый Структура;
	Структура.Вставить("ДоговорКонтрагента", ПараметрКоманды.ДоговорКонтрагента);
	Структура.Вставить("НастройкиКомпоновщика", КомпоновщикНастроек.ПолучитьНастройки());
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти


