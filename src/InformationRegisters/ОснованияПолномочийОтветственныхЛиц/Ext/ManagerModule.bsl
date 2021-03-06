#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДолжностиФизическихЛицИзОтветственныхЛиц(ПараметрыОбновления = Неопределено) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.СведенияОбОтветственныхЛицах") Тогда
		МодульСведенияОбОтветственныхЛицах = ОбщегоНазначения.ОбщийМодуль("СведенияОбОтветственныхЛицах");
		МодульСведенияОбОтветственныхЛицах.СоздатьВТУдаленныеДолжностиОтветственныхЛицОрганизаций(МенеджерВременныхТаблиц);
	КонецЕсли;

	Если Не ЗарплатаКадры.ВТСуществует(МенеджерВременныхТаблиц, "ВТУдаленныеДолжностиОтветственныхЛицОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УдаленныеДолжности.Организация КАК Организация,
		|	УдаленныеДолжности.ФизическоеЛицо КАК ФизическоеЛицо,
		|	УдаленныеДолжности.Должность КАК Должность,
		|	"""" КАК ОснованиеПодписи
		|ИЗ
		|	ВТУдаленныеДолжностиОтветственныхЛицОрганизаций КАК УдаленныеДолжности
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОснованияПолномочийОтветственныхЛиц КАК ОснованияПолномочийОтветственныхЛиц
		|		ПО УдаленныеДолжности.Организация = ОснованияПолномочийОтветственныхЛиц.Организация
		|			И УдаленныеДолжности.ФизическоеЛицо = ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо
		|ГДЕ
		|	ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо ЕСТЬ NULL";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ОснованияПолномочийОтветственныхЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НаборЗаписей.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
		
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
	КонецЦикла;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);

КонецПроцедуры

#КонецОбласти


#КонецЕсли