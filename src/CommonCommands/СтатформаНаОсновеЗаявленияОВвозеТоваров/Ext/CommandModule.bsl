﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Документ.ЗаявлениеОВвозеТоваров.Форма.ФормаДокумента" Тогда
		ТекущийЭлементСписка = ПараметрыВыполненияКоманды.Источник.Объект;
	ИначеЕсли ПараметрыВыполненияКоманды.Источник.Элементы.Найти("Список") <> Неопределено Тогда
		ТекущийЭлементСписка = ПараметрыВыполненияКоманды.Источник.Элементы.Список.ТекущиеДанные;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ТекущийЭлементСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетностьВФТС = ОпределитьСсылкуНаСуществующийОтчетВФТС(ТекущийЭлементСписка.Ссылка);
	
	Если НЕ ЗначениеЗаполнено(ОтчетностьВФТС) Тогда
		Попытка
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", НачалоМесяца(ТекущийЭлементСписка.Дата));
			ПараметрыФормы.Вставить("мСохраненныйДок",          Неопределено);
			ПараметрыФормы.Вставить("мСкопированаФорма",        Неопределено);
			ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  КонецМесяца(ТекущийЭлементСписка.Дата));
			ПараметрыФормы.Вставить("мПериодичность",           ПредопределенноеЗначение("Перечисление.Периодичность.Месяц"));
			ПараметрыФормы.Вставить("Организация",              ТекущийЭлементСписка.Организация);
			ПараметрыФормы.Вставить("мВыбраннаяФорма",          "ФормаОтчетаПоЗаявлениюОВвозеТоваров");
			ПараметрыФормы.Вставить("ЗаявлениеОВвозеТоваров",   ТекущийЭлементСписка.Ссылка);
			ПараметрыФормы.Вставить("НужноОповещатьОСоздании");
			
			ПолучитьФорму("Отчет.РегламентированныйОтчетСтатистикаФормаУчетаПеремещенияТоваровТС.Форма.ФормаОтчетаПоЗаявлениюОВвозеТоваров", ПараметрыФормы).Открыть();
			
		Исключение
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось открыть форму отчета ""Статистическая форма учета перемещения товаров"".'"));
			
		КонецПопытки;
	Иначе
		ПоказатьЗначение(,ОтчетностьВФТС);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОпределитьСсылкуНаСуществующийОтчетВФТС(ЗНАЧ ЗаявлениеОВвозе)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидОтчетности", Перечисления.ВидыОтчетности.РегламентированнаяОтчетность);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	РегламентированныйОтчет.Ссылка,
	               |	РегламентированныйОтчет.ДанныеОтчета
	               |ИЗ
	               |	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	               |ГДЕ
	               |	РегламентированныйОтчет.ВидОтчетности = &ВидОтчетности
	               |	И РегламентированныйОтчет.ИсточникОтчета = ""РегламентированныйОтчетСтатистикаФормаУчетаПеремещенияТоваровТС""";
	
	Результат = Запрос.Выполнить().Выгрузить();
	Для каждого Стр Из Результат Цикл
		ДанныеОтчета = Стр.ДанныеОтчета.Получить();
		
		Если ТипЗнч(ДанныеОтчета) <> Тип("Структура") ИЛИ НЕ ДанныеОтчета.Свойство("ЗаявлениеОВвозеТоваров") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДанныеОтчета.ЗаявлениеОВвозеТоваров.Ссылка = ЗаявлениеОВвозе Тогда
			Возврат Стр.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции