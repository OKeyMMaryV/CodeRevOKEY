
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ТаблицаЗаболеваний.РежимВыбора = Истина;
	
	ТаблицаЗаболеваний.Загрузить(Документы.БольничныйЛист.ПредставлениеПричиныЗаболевания());
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаболеванийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЭтотОбъект.Закрыть(СформироватьВозвращаемыеПараметры(ТаблицаЗаболеваний[ВыбраннаяСтрока]));
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаболеванийВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ЭтотОбъект.Закрыть(СформироватьВозвращаемыеПараметры(Элементы.ТаблицаЗаболеваний.ТекущиеДанные));
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьВозвращаемыеПараметры(ТекущиеДанные)
	
	СтруктураПараметров = Новый Структура("Наименование, ПричинаНетрудоспособности, СлучайУходаЗаБольнымРебенком");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ТекущиеДанные);
	
	Возврат СтруктураПараметров;
	
КонецФункции
